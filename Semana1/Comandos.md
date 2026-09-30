# Listado de Comandos básicos

| ¿Qué hace el comando? | Windows (PowerShell) | Linux (Bash) |
| :--- | :--- | :--- |
| **Ver características de la Memoria RAM** | `Get-CimInstance Win32_PhysicalMemory` | `free -h` o `cat /proc/meminfo` |
| **Ver propiedades del disco duro** | `Get-PhysicalDisk` y `Get-Volume` | `lsblk` y `df -h` |
| **Ver propiedades de E/S** | `Get-PnpDevice -PresentOnly` | `lsusb` o `lspci` |
| **Ver resumen de propiedades del hardware** | `systeminfo` o `msinfo32` | `lshw` o `inxi -F` |