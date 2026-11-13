#!/usr/bin/env bash
# ==============================================================================
# ESCUELA POLITÉCNICA NACIONAL - FIEEC
# Asignatura: Sistemas Operativos | Semana 4 - Deber 4
# Script: verificador_entorno.sh
# Autores: Nicolas Galán y Leonardo Vilanez
# Fecha: Noviembre 2026
# Declaración de IA: Asistencia en estructuración de formato de salida y validaciones.
# Descripción: Audita el sistema, herramientas requeridas, repositorios,
#              historial de instalaciones y genera informe sin usar sudo.
# ==============================================================================

set -u

EQUIPO=$(hostname -s 2>/dev/null || echo "fieecec-almalinux")
ARCHIVO_SALIDA="verificador_entorno_${EQUIPO}.txt"

exec > >(tee "$ARCHIVO_SALIDA") 2>&1

echo "======================================================================"
echo "         VERIFICADOR DE ENTORNO DE SISTEMAS OPERATIVOS (LINUX)        "
echo "======================================================================"
echo "Fecha de ejecución : $(date '+%Y-%m-%d %H:%M:%S')"
echo "Equipo             : $EQUIPO"
echo "Usuario            : $(whoami)"
echo ""

# ------------------------------------------------------------------------------
# SECCIÓN 1: Sistema y Shell
# ------------------------------------------------------------------------------
echo "--- [1] SISTEMA Y SHELL ---"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Distribución       : ${PRETTY_NAME:-$NAME}"
else
    echo "Distribución       : Desconocida (/etc/os-release no disponible)"
fi
echo "Kernel             : $(uname -sr)"
echo "Arquitectura       : $(uname -m)"
echo "Versión de Bash    : ${BASH_VERSION}"
echo "Terminal actual    : $(tty 2>/dev/null || echo 'No interactiva')"
echo ""

# ------------------------------------------------------------------------------
# SECCIÓN 2: Herramientas requeridas
# ------------------------------------------------------------------------------
echo "--- [2] HERRAMIENTAS REQUERIDAS ---"
HERRAMIENTAS=("git" "curl" "python3" "jq" "strace" "tree")
TOTAL=${#HERRAMIENTAS[@]}
LISTAS=0
FALTANTES=()

printf "%-12s | %-8s | %-22s | %s\n" "Herramienta" "Estado" "Ruta" "Versión"
echo "----------------------------------------------------------------------"

for cmd in "${HERRAMIENTAS[@]}"; do
    if RUTA=$(command -v "$cmd" 2>/dev/null); then
        VER=$("$cmd" --version 2>&1 | head -n 1 | cut -c 1-35)
        printf "%-12s | %-8s | %-22s | %s\n" "$cmd" "OK" "$RUTA" "$VER"
        LISTAS=$((LISTAS + 1))
    else
        printf "%-12s | %-8s | %-22s | %s\n" "$cmd" "FALTA" "-" "No instalado"
        FALTANTES+=("$cmd")
    fi
done
echo ""

# ------------------------------------------------------------------------------
# SECCIÓN 3: Paquetes y orígenes
# ------------------------------------------------------------------------------
echo "--- [3] PAQUETES Y ORÍGENES ---"
if command -v rpm >/dev/null 2>&1; then
    TOTAL_RPM=$(rpm -qa | wc -l)
    echo "Total paquetes RPM instalados : $TOTAL_RPM"
    echo ""
    echo "Paquete propietario de cada herramienta instalada:"
    for cmd in "${HERRAMIENTAS[@]}"; do
        if RUTA=$(command -v "$cmd" 2>/dev/null); then
            PAQUETE=$(rpm -qf "$RUTA" 2>/dev/null || echo "Desconocido")
            printf "  - %-10s -> %s\n" "$cmd" "$PAQUETE"
        fi
    done
fi
echo ""
if command -v dnf >/dev/null 2>&1; then
    echo "Repositorios activos (dnf repolist):"
    dnf repolist 2>/dev/null | sed 's/^/  /'
else
    echo "Aviso: gestor dnf no disponible en este sistema."
fi
echo ""

# ------------------------------------------------------------------------------
# SECCIÓN 4: Últimas 5 instalaciones
# ------------------------------------------------------------------------------
echo "--- [4] ÚLTIMAS 5 INSTALACIONES ---"
if command -v dnf >/dev/null 2>&1; then
    echo "Historial reciente de transacciones (dnf history):"
    dnf history list 2>/dev/null | head -n 7 | sed 's/^/  /'
    echo ""
    echo "Últimos 5 paquetes instalados según base RPM:"
    rpm -qa --last | head -n 5 | sed 's/^/  /'
else
    echo "No se pudo consultar el historial de dnf."
fi
echo ""

# ------------------------------------------------------------------------------
# SECCIÓN 5: Qué falta y cómo instalarlo (Incluye Reto Final Taller 2)
# ------------------------------------------------------------------------------
echo "--- [5] QUÉ FALTA Y CÓMO INSTALARLO ---"
if [ "${#FALTANTES[@]}" -eq 0 ]; then
    echo "Todas las herramientas requeridas están instaladas correctamente."
else
    echo "Faltan ${#FALTANTES[@]} herramienta(s): ${FALTANTES[*]}"
    echo "Comando exacto para instalar todo lo que falta de una sola vez:"
    echo "  sudo dnf install -y ${FALTANTES[*]}"
fi
echo ""

# ------------------------------------------------------------------------------
# SECCIÓN 6: Resultado final
# ------------------------------------------------------------------------------
echo "--- [6] RESULTADO ---"
echo "Herramientas listas: ${LISTAS} de ${TOTAL}"
echo "Informe guardado en: ${ARCHIVO_SALIDA}"

if [ "$LISTAS" -eq "$TOTAL" ]; then
    echo "Estado final       : COMPLETO (Código de salida: 0)"
    exit 0
else
    echo "Estado final       : INCOMPLETO (Código de salida: 1)"
    exit 1
fi

