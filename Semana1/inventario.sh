#!/usr/bin/env bash
# inventario.sh - Semana 1
salida="inventario_$(hostname).txt"

{
    echo "== Equipo: $(hostname) | $(date)"
    echo "== SO: $(. /etc/os-release; echo $PRETTY_NAME)"
    echo "== CPU"
    lscpu | grep -E 'Model name|^CPU\(s\)|Thread|L1|L2|L3'
    echo "== Memoria"
    free -h | head -2
    echo "== Discos"
    lsblk -do NAME,SIZE,TYPE
    echo "== Red (Extra)"
    ip -br addr
} > "$salida"
echo "Reporte generado: $salida"
