

# Ayuda Memoria - Comandos de Arquitectura (Semana 1)

| Bloque Funcional | Comando Linux (Bash) | Comando Windows (PowerShell) | Descripción |
| :--- | :--- | :--- | :--- |
| **CPU** | `lscpu` / `cat /proc/cpuinfo` | `Get-CimInstance Win32_Processor` | Identifica modelo, núcleos, hilos y tamaños de caché L1, L2 y L3. |
| **Memoria** | `free -h` / `cat /proc/meminfo` | `Get-CimInstance Win32_PhysicalMemory` | Muestra capacidad total, utilizada y disponible de la RAM. |
| **Almacenamiento** | `lsblk -do NAME,SIZE,TYPE` / `df -h` | `Get-PhysicalDisk` / `Get-Volume` | Lista los discos físicos, volúmenes montados y tamaño. |
| **Buses y E/S** | `lspci` / `lsusb` | `Get-PnpDevice -PresentOnly` | Muestra dispositivos conectados por buses PCIe, USB y controladores. |
| **Resumen SO** | `uname -a` / `cat /etc/os-release` | `systeminfo` / `msinfo32` | Reporte general del equipo, arquitectura y sistema operativo. |
| **Red (Extra)** | `ip -br addr` | `Get-NetIPAddress -AddressFamily IPv4` | Lista adaptadores e interfaces de red con sus direcciones IP. |
