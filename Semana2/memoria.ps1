# memoria.ps1 — Deber 2, semana 2
# Estudiantes: Nicolás Galán, Leonardo Vilañez
$salida = "memoria_$env:COMPUTERNAME.txt"
$os = Get-CimInstance Win32_OperatingSystem

& {
    "== Equipo: $env:COMPUTERNAME $(Get-Date -f d)"
    "== Arquitectura: $env:PROCESSOR_ARCHITECTURE"
    "LittleEndian: $([BitConverter]::IsLittleEndian)"
    
    "`n== Cachés (KB)"
    Get-CimInstance Win32_CacheMemory | Select-Object Purpose, InstalledSize, Associativity, LineSize | Format-Table -AutoSize
    
    "`n== RAM y Memoria Virtual (GB)"
    [PSCustomObject]@{
        TotalRAM_GB     = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        FreeRAM_GB      = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        TotalVirtual_GB = [math]::Round($os.TotalVirtualMemorySize / 1MB, 2)
        FreeVirtual_GB  = [math]::Round($os.FreeVirtualMemory / 1MB, 2)
    } | Format-Table -AutoSize

    "`n== Discos Físicos"
    Get-PhysicalDisk | Select-Object FriendlyName, MediaType, @{Name="Size_GB";Expression={[math]::Round($_.Size / 1GB, 2)}} | Format-Table -AutoSize
} | Out-File -Encoding utf8 $salida

"Reporte: $salida"
