### Listado de Comandos básicos del Sistema Operativo

| Acción a realizar | Comando en Windows (PowerShell) | Comando en Linux (Bash) | ¿Qué hace este comando? |
| :--- | :--- | :--- | :--- |
| **Ver memoria RAM** | `Get-CimInstance Win32_PhysicalMemory` | `free -h` o `cat /proc/meminfo` | Muestra la cantidad de memoria RAM instalada y el espacio disponible. |
| **Ver disco duro** | `Get-PhysicalDisk` y `Get-Volume` | `lsblk` y `df -h` | Muestra los discos físicos conectados y el espacio libre en las particiones. |
| **Ver dispositivos de E/S** | `Get-PnpDevice -PresentOnly` | `lsusb` o `lspci` | Lista los periféricos y componentes de hardware (Entrada/Salida) conectados al equipo. |
| **Resumen del sistema** | `systeminfo` o `msinfo32` | `lshw` o `inxi -F` | Despliega un resumen general de las propiedades del sistema operativo y del hardware. |
