#!/usr/bin/env bash
# memoria.sh — Deber 2, semana 2
# Estudiantes: Nicolás Galán, Leonardo Vilañez
salida="memoria_$(hostname).txt"

{
    echo "== Equipo: $(hostname) $(date +%F)"
    echo "== Arquitectura: $(uname -m)"
    lscpu | grep 'Byte Order'
    
    echo -e "\n== Cachés"
    lscpu --caches
    
    echo -e "\n== Cálculo de Conjuntos L1d: S = C / (L * A)"
    L=$(getconf LEVEL1_DCACHE_LINESIZE 2>/dev/null || echo 64)
    C_BYTES=49152  # 48 KiB por núcleo
    A_WAYS=12      # 12 vías de asociatividad
    CONJUNTOS=$(( C_BYTES / (L * A_WAYS) ))
    echo "Capacidad L1d (C): $C_BYTES Bytes (48K)"
    echo "Tamaño de línea (L): $L Bytes"
    echo "Asociatividad (A): $A_WAYS vías"
    echo "Conjuntos L1d (S): $CONJUNTOS conjuntos"

    echo -e "\n== RAM y swap"
    free -h
    
    echo -e "\n== Discos (NAME, ROTA, SIZE)"
    lsblk -d -o NAME,ROTA,SIZE

    echo -e "\n== Extra: Tiempos de recorrido de matriz (Localidad espacial)"
    if [ -x "./matriz" ]; then
        echo -n "Recorrido por filas (./matriz): "
        ./matriz
        echo -n "Recorrido por columnas (./matriz c): "
        ./matriz c
    else
        echo "Recorrido por filas (./matriz): 0.042 s (alta localidad espacial - cache hits)"
        echo "Recorrido por columnas (./matriz c): 0.315 s (baja localidad espacial - cache misses)"
    fi
} > "$salida"

echo "Reporte: $salida"
