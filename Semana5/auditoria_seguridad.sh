#!/usr/bin/env bash
# ==============================================================================
# Script      : auditoria_seguridad.sh
# Asignatura  : Sistemas Operativos (EPN - FIEEC) · Semana 5 / Deber 5
# Autores     : Nicolas Galan, Leonardo Vilanez
# Fecha       : 2026-11-16
# Descripcion : Audita 5 controles de seguridad en AlmaLinux sin requerir sudo:
#               (1) Llavero maestro (UID 0 y wheel), (2) Puertas abiertas,
#               (3) Portero activo (firewalld), (4) Intentos fallidos SSH,
#               (5) Veredicto consolidado (exit 0 = OK, exit 1 = ALERTA).
# Uso de IA   : Asistencia en estructuracion modular de funciones y expresiones
#               regulares awk para parseo de bitacoras. Validado por el equipo.
# ==============================================================================

MUESTRA=""
UMBRAL=5

while getopts "m:u:h" opt; do
    case "$opt" in
        m) MUESTRA="$OPTARG" ;;
        u) UMBRAL="$OPTARG" ;;
        h)
            echo "Uso: $0 [-m ruta_auth.log] [-u umbral_fallos]"
            exit 0
            ;;
        *)
            echo "Opcion invalida. Use -h para ayuda." >&2
            exit 1
            ;;
    esac
done

HOST=$(hostname)
FECHA=$(date "+%Y-%m-%d %H:%M:%S")
SALIDA="auditoria_${HOST}.txt"

ESTADO_S1="OK"
ESTADO_S2="OK"
ESTADO_S3="OK"
ESTADO_S4="OK"

# ------------------------------------------------------------------------------
# Seccion 1: Llavero maestro
# Regla de ALERTA: Existe alguna cuenta con UID 0 distinta de 'root'.
# ------------------------------------------------------------------------------
seccion_1_llavero() {
    echo "------------------------------------------------------------------"
    echo "[SECCION 1] LLAVERO MAESTRO (UID 0 Y GRUPO WHEEL)"
    echo "------------------------------------------------------------------"
    local uids_cero
    uids_cero=$(awk -F: '$3==0 {print $1}' /etc/passwd)
    local grupo_wheel
    grupo_wheel=$(getent group wheel | cut -d: -f4)

    echo "Cuentas con UID 0 en /etc/passwd : ${uids_cero//$'\n'/, }"
    echo "Miembros del grupo wheel         : ${grupo_wheel:-ninguno}"

    local extra_root
    extra_root=$(awk -F: '$3==0 && $1!="root" {print $1}' /etc/passwd)
    if [[ -n "$extra_root" ]]; then
        ESTADO_S1="ALERTA"
        echo "Detalle: Cuenta(s) no autorizada(s) con UID 0: $extra_root"
    fi
    echo "-> Seccion 1: $ESTADO_S1"
    echo ""
}

# ------------------------------------------------------------------------------
# Seccion 2: Puertas abiertas
# Regla de ALERTA: Puertos 21, 23, 3306, 3389 o 5900 escuchando hacia la red.
# ------------------------------------------------------------------------------
seccion_2_puertas() {
    echo "------------------------------------------------------------------"
    echo "[SECCION 2] PUERTAS ABIERTAS (PUERTOS TCP EN ESCUCHA)"
    echo "------------------------------------------------------------------"
    local puertos_tcp
    puertos_tcp=$(ss -H -tln)
    echo "$puertos_tcp" | awk '{printf "  %-8s %-25s\n", $1, $4}'

    # Buscar puertos inseguros expuestos fuera de loopback (127.0.0.1 o [::1])
    local expuestos
    expuestos=$(echo "$puertos_tcp" | awk '$4 !~ /^(127\.0\.0\.1|\[::1\]):/ {print $4}' | grep -E ':(21|23|3306|3389|5900)$' || true)

    if [[ -n "$expuestos" ]]; then
        ESTADO_S2="ALERTA"
        echo "Detalle: Puerto(s) inseguro(s) expuesto(s) a la red:"
        echo "$expuestos"
    fi
    echo "-> Seccion 2: $ESTADO_S2"
    echo ""
}

# ------------------------------------------------------------------------------
# Seccion 3: Portero activo
# Regla de ALERTA: El servicio firewalld no se encuentra en estado 'active'.
# ------------------------------------------------------------------------------
seccion_3_portero() {
    echo "------------------------------------------------------------------"
    echo "[SECCION 3] PORTERO ACTIVO (ESTADO DE FIREWALLD)"
    echo "------------------------------------------------------------------"
    local fw_estado
    fw_estado=$(systemctl is-active firewalld 2>/dev/null || true)
    echo "Estado del servicio firewalld: ${fw_estado:-desconocido}"

    if [[ "$fw_estado" != "active" ]]; then
        ESTADO_S3="ALERTA"
        echo "Detalle: El cortafuegos firewalld no esta activo."
    fi
    echo "-> Seccion 3: $ESTADO_S3"
    echo ""
}

# ------------------------------------------------------------------------------
# Seccion 4: Intentos fallidos (IDS)
# Regla de ALERTA: Alguna IP alcanza o supera el umbral (-u) en intentos SSH.
# ------------------------------------------------------------------------------
seccion_4_bitacora() {
    echo "------------------------------------------------------------------"
    echo "[SECCION 4] INTENTOS FALLIDOS POR SSH (UMBRAL: $UMBRAL)"
    echo "------------------------------------------------------------------"
    local fuente_datos
    if [[ -n "$MUESTRA" ]]; then
        if [[ ! -f "$MUESTRA" ]]; then
            echo "Error: No se encuentra el archivo de muestra '$MUESTRA'."
            ESTADO_S4="ALERTA"
            echo "-> Seccion 4: $ESTADO_S4"
            echo ""
            return
        fi
        echo "Fuente analizada: Archivo de muestra ($MUESTRA)"
        fuente_datos=$(grep "Failed password" "$MUESTRA" 2>/dev/null || true)
    else
        echo "Fuente analizada: journalctl -u sshd (ultimas 24 horas)"
        fuente_datos=$(journalctl -u sshd --since "24 hours ago" --no-pager 2>/dev/null | grep "Failed password" || true)
    fi

    if [[ -z "$fuente_datos" ]]; then
        echo "No se registraron intentos fallidos por SSH."
    else
        local conteo_ips
        conteo_ips=$(echo "$fuente_datos" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -rn)
        echo "Conteo de fallos por IP:"
        echo "$conteo_ips" | awk '{printf "  %4d fallos -> %s\n", $1, $2}'

        local superan
        superan=$(echo "$conteo_ips" | awk -v lim="$UMBRAL" '$1 >= lim {print $2 " (" $1 " fallos)"}')
        if [[ -n "$superan" ]]; then
            ESTADO_S4="ALERTA"
            echo "Detalle: IP(s) que alcanzan o superan el umbral ($UMBRAL):"
            echo "$superan" | sed 's/^/  - /'
        fi
    fi
    echo "-> Seccion 4: $ESTADO_S4"
    echo ""
}

# ------------------------------------------------------------------------------
# Seccion 5: Veredicto final
# Regla de retorno: 0 si todas las secciones estan OK; 1 si hay alguna ALERTA.
# ------------------------------------------------------------------------------
seccion_5_veredicto() {
    echo "=================================================================="
    echo "[SECCION 5] VEREDICTO CONSOLIDADO DE AUDITORIA"
    echo "=================================================================="
    echo "  1. Llavero maestro   : $ESTADO_S1"
    echo "  2. Puertas abiertas  : $ESTADO_S2"
    echo "  3. Portero activo    : $ESTADO_S3"
    echo "  4. Intentos fallidos : $ESTADO_S4"
    echo "------------------------------------------------------------------"

    if [[ "$ESTADO_S1" == "OK" && "$ESTADO_S2" == "OK" && "$ESTADO_S3" == "OK" && "$ESTADO_S4" == "OK" ]]; then
        echo "VEREDICTO FINAL: OK (Equipo conforme a la politica base)"
        echo "=================================================================="
        return 0
    else
        echo "VEREDICTO FINAL: ALERTA (Se requiere revision de seguridad)"
        echo "=================================================================="
        return 1
    fi
}

ejecutar_auditoria() {
    echo "=================================================================="
    echo " REPORTE DE AUDITORIA DE SEGURIDAD - LINUX (BASH)"
    echo " Equipo: $HOST | Fecha: $FECHA"
    echo "=================================================================="
    echo ""
    seccion_1_llavero
    seccion_2_puertas
    seccion_3_portero
    seccion_4_bitacora
    seccion_5_veredicto
}

ejecutar_auditoria | tee "$SALIDA"
exit "${PIPESTATUS[0]}"
