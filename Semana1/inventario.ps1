# inventario.ps1 - Semana 1
$salida = "inventario_$env:COMPUTERNAME.txt"
$cpu = Get-CimInstance Win32_Processor
$os = Get-CimInstance Win32_OperatingSystem

& {
    "== Equipo: $env:COMPUTERNAME | $(Get-Date)"
    "== SO: $($os.Caption) $($os.Version)"
    "== CPU"
    $cpu | Format-List Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
    "== RAM (GB): {0:N1}" -f ($os.TotalVisibleMemorySize/1MB)
    "== Discos"
    Get-PhysicalDisk | Format-Table FriendlyName, Size
    "== Red (Extra)"
    Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress
} | Out-File $salida
Write-Host "Reporte generado: $salida"
