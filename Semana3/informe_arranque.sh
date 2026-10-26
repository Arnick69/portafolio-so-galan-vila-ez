#!/usr/bin/env bash
# ==============================================================================
# Script      : informe_arranque.sh
# Asignatura  : Sistemas Operativos - Semana 3 (Deber 3)
# Docente     : Ing. Rubén Rumipamba
# Autores     : Nicolás Galán, Leonardo Vilañez
# Paralelo    : GR1
# Fecha       : 2026-10-19
# Declaración : Uso de IA generativa (Gemini) como apoyo para verificar el manejo
#               de errores sin sudo mediante la función 'tiene' y dar formato
#               legible a las 6 secciones del informe.
# ==============================================================================

EQUIPO=$(hostname -s 2>/dev/null || hostname 2>/dev/null || echo "localhost")
FECHA=$(date +%F)
SALIDA="informe_arranque_${EQUIPO}_${FECHA}.txt"

tiene() {
    command -v "$1" >/dev/null 2>&1
}

{
    echo "=================================================================="
    echo "          INFORME DE ARRANQUE DEL SISTEMA (GNU/LINUX)             "
    echo "=================================================================="
    echo "Equipo  : $EQUIPO"
    echo "Fecha   : $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Autores : Nicolás Galán, Leonardo Vilañez (GR1)"
    echo "=================================================================="
    echo ""

    # 1 · Sistema operativo, versión y núcleo
    echo "=== 1 · Sistema operativo, versión y núcleo ==="
    if [ -r /etc/os-release ]; then
        PRETTY=$(. /etc/os-release && echo "$PRETTY_NAME")
    else
        PRETTY="No disponible"
    fi
    echo "Sistema: $PRETTY"
    echo "Núcleo : $(uname -r) ($(uname -m))"
    echo ""

    # 2 · Último arranque y tiempo encendido
    echo "=== 2 · Último arranque y tiempo encendido ==="
    if tiene uptime; then
        echo "Arrancó  : $(uptime -s 2>/dev/null || echo 'No disponible')"
        echo "Encendida: $(uptime -p 2>/dev/null || uptime)"
    else
        echo "[AVISO] El comando 'uptime' no está disponible."
    fi
    echo ""

    # 3 · Desglose del arranque (systemd-analyze)
    echo "=== 3 · Desglose del arranque (systemd-analyze) ==="
    if tiene systemd-analyze; then
        RES_TIME=$(systemd-analyze time 2>&1)
        if [ $? -eq 0 ]; then
            echo "$RES_TIME"
        else
            echo "[AVISO] No se pudo medir el arranque con systemd-analyze: $RES_TIME"
        fi
    else
        echo "[AVISO] El comando 'systemd-analyze' no existe en este sistema."
    fi
    echo ""

    # 4 · Cinco unidades más lentas
    echo "=== 4 · Cinco unidades más lentas (blame) ==="
    if tiene systemd-analyze; then
        RES_BLAME=$(systemd-analyze blame --no-pager 2>/dev/null | head -n 5)
        if [ -n "$RES_BLAME" ]; then
            echo "$RES_BLAME"
        else
            echo "[AVISO] No se pudieron obtener las unidades más lentas sin permisos adicionales."
        fi
    else
        echo "[AVISO] 'systemd-analyze blame' no está disponible."
    fi
    echo ""

    # 5 · Módulos del núcleo
    echo "=== 5 · Módulos del núcleo (lsmod) ==="
    if tiene lsmod && [ -r /proc/modules ]; then
        TOTAL_MOD=$(lsmod | tail -n +2 | wc -l)
        echo "Total de módulos cargados: $TOTAL_MOD"
        echo "Cinco módulos más grandes (Nombre | Tamaño en bytes | Usado por):"
        lsmod | tail -n +2 | sort -k2 -nr | head -n 5 | awk '{printf "  - %-22s %10s bytes (usado por: %s)\n", $1, $2, $3}'
    else
        echo "[AVISO] No es posible leer los módulos cargados (lsmod no disponible)."
    fi
    echo ""

    # 6 · Cierre (Target por defecto y unidades fallidas)
    echo "=== 6 · Cierre: Target por defecto y unidades fallidas ==="
    if tiene systemctl; then
        echo "Target por defecto: $(systemctl get-default 2>/dev/null || echo 'No disponible')"
        echo "Unidades con fallo (systemctl --failed):"
        FALLOS=$(systemctl --failed --no-legend --no-pager 2>/dev/null)
        if [ -z "$FALLOS" ]; then
            echo "  0 unidades fallidas (sistema limpio)."
        else
            echo "$FALLOS"
        fi
    else
        echo "[AVISO] El comando 'systemctl' no está disponible."
    fi
    echo ""
    echo "=== Fin del informe ==="

} | tee "$SALIDA"

echo ""
echo "Informe generado en: $SALIDA"
