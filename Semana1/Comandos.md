# Ayuda Memoria: Comandos Windows vs Linux

| Comando Windows (PowerShell / CMD) | Comando Linux (Bash) | ¿Qué hace? |
| :--- | :--- | :--- |
| `Get-Location` / `pwd` | `pwd` | Muestra la ruta del directorio de trabajo actual. |
| `Set-Location <ruta>` / `cd` | `cd <ruta>` | Cambia el directorio de trabajo a la ruta indicada. |
| `Get-ChildItem` / `dir` | `ls` / `ls -la` | Lista archivos y carpetas del directorio. |
| `New-Item -ItemType Directory` / `mkdir` | `mkdir <nombre>` | Crea un nuevo directorio. |
| `New-Item -ItemType File` / `type nul >` | `touch <nombre>` | Crea un archivo vacío. |
| `Copy-Item <origen> <destino>` | `cp <origen> <destino>` | Copia archivos o directorios. |
| `Move-Item <origen> <destino>` | `mv <origen> <destino>` | Mueve o renombra archivos o directorios. |
| `Remove-Item <archivo>` | `rm <archivo>` | Elimina archivos o directorios. |
| `Get-Content <archivo>` / `cat` | `cat <archivo>` | Muestra el contenido de un archivo en consola. |
| `Clear-Host` / `cls` | `clear` | Limpia la pantalla de la terminal. |
| `Get-Process` | `ps aux` / `top` | Lista los procesos activos en ejecución. |
| `Stop-Process -Name <proceso>` | `kill <PID>` / `pkill` | Detiene o finaliza un proceso. |
| `Get-NetIPAddress` / `ipconfig` | `ip addr` / `ifconfig` | Muestra la configuración de red y direcciones IP. |
| `systeminfo` | `uname -a` | Muestra información del sistema operativo y hardware. |
| `Format-Hex <archivo>` | `hexdump -C <archivo>` / `xxd` | Muestra la representación en bytes/hexadecimal de un archivo. |
