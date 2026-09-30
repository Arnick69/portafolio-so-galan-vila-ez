# Listado de Comandos básicos
## S.O. Windows con PowerShell

### Ver características de la Memoria RAM
Get-CimInstance Win32_PhysicalMemory

### Ver propiedades del disco duro
Get-PhysicalDisk
Get-Volume

### Ver propiedades de E/S
Get-PnpDevice -PresentOnly

### Ver resumen de propiedades del hardware
systeminfo - msinfo32


## S.O. Linux con bash