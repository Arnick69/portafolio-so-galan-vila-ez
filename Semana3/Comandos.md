# Ayuda Memoria de Comandos: Linux (Bash) vs. Windows (PowerShell) · Semana 3

* **Asignatura:** Sistemas Operativos
* **Docente:** Ing. Rubén Rumipamba
* **Integrantes:** Nicolás Galán, Leonardo Vilañez
* **Paralelo:** GR1

---

## 1. Departamentos del Sistema Operativo y Espera de E/S (Taller 1)

| Departamento / Acción | Linux (AlmaLinux · Bash) | Windows (PowerShell) | Concepto y Funcionamiento |
| :--- | :--- | :--- | :--- |
| **Procesos en total** | `ps -e --no-headers \| wc -l` | `(Get-Process).Count` | Cuenta el total de procesos o tareas activas en memoria. |
| **Primer proceso (Raíz)** | `ps -p 1 -o pid,comm`<br>`pstree -p \| head -n 12` | `Get-Process -Id 4` | En Linux es `systemd` (PID 1), raíz del árbol de procesos; en Windows es `System` (PID 4), que agrupa los hilos del núcleo. |
| **Núcleos lógicos (CPU)** | `nproc` | `(Get-CimInstance Win32_Processor).NumberOfLogicalProcessors` | Muestra cuántos procesadores lógicos ("cocineros") tiene disponibles el equipo. |
| **Servicios activos** | `systemctl list-units --type=service --state=running --no-legend \| wc -l` | `(Get-Service \| Where-Object Status -eq Running).Count` | Lista o cuenta los *daemons* o servicios que corren en segundo plano sin ventana. |
| **Memoria RAM y Swap** | `free -h` | `Get-CimInstance Win32_OperatingSystem \| Select-Object TotalVisibleMemorySize, FreePhysicalMemory` | Muestra la capacidad total y libre de la memoria principal ("la mesada"). |
| **Discos y particiones** | `lsblk` | `Get-CimInstance Win32_LogicalDisk \| Select-Object DeviceID, Size, FreeSpace` | Lista los dispositivos de almacenamiento secundario y sus particiones o volúmenes. |
| **Ventana al núcleo** | `grep -m1 "model name" /proc/cpuinfo`<br>`head -n 3 /proc/meminfo`<br>`cat /proc/uptime` | `Get-CimInstance Win32_OperatingSystem \| Select-Object Caption, Version, LastBootUpTime` | En Linux `/proc` es un sistema de archivos virtual en RAM; en Windows el estado se consulta mediante clases `CIM / WMI`. |
| **Dispositivos (`/dev`)** | `ls -l /dev/null /dev/tty /dev/sda` | *(Objetos de dispositivo expuestos por CIM/WMI)* | En Linux cada dispositivo se trata como un archivo: `b` para bloques (discos) y `c` para caracteres (terminal, teclado). |
| **CPU ociosa (%)** | `vmstat 1 2` *(columnas `id` y `wa`)* | `Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -Filter "Name='_Total'" \| Select-Object PercentIdleTime` | Mide el porcentaje de tiempo en que la CPU estuvo inactiva (`id` / `PercentIdleTime`) y esperando al disco (`wa`). |
| **Medición de espera ($p$)** | `time <comando>` | `Start-Process ... -PassThru` *(midiendo `ExitTime - StartTime` y `TotalProcessorTime`)* | Permite obtener `real`, `user` y `sys` para calcular la fracción de espera $p = 1 - (\text{user} + \text{sys}) / \text{real}$. |

---

## 2. Diagnóstico del Arranque, Módulos y Parada Ordenada (Taller 2 y Deber 3)

| Acción / Etapa | Linux (AlmaLinux · Bash) | Windows (PowerShell) | Concepto y Funcionamiento |
| :--- | :--- | :--- | :--- |
| **Último arranque y uptime** | `uptime -s`<br>`uptime -p` | `(Get-CimInstance Win32_OperatingSystem).LastBootUpTime` | Muestra la fecha y hora exacta del último arranque completo del núcleo y el tiempo encendido. |
| **Tiempo de Firmware** | *(Visible en máquina física con `systemd-analyze`)* | `(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power').FwPOSTTime` | Mide cuánto tardó la inicialización de BIOS/UEFI (POST) antes de entregar el control al cargador. |
| **Desglose del arranque** | `systemd-analyze time` | `Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Diagnostics-Performance/Operational'; Id=100} -MaxEvents 1` | Divide el tiempo de arranque en `kernel`, `initrd` y `userspace` (o `MainPathBootTime` y `BootPostBootTime` en Windows). |
| **Unidades más lentas** | `systemd-analyze blame --no-pager \| head -n 5` | `Get-CimInstance Win32_Service` *(y Eventos 101–103)* | Ordena las unidades o servicios según el tiempo que tardaron en arrancar. |
| **Cadena crítica** | `systemd-analyze critical-chain --no-pager` | *(Visor de Eventos Diagnósticos de Rendimiento)* | Muestra las unidades que realmente hicieron esperar a las demás hasta alcanzar el `target` final. |
| **Registro del arranque** | `journalctl -b -p warning --no-pager`<br>`sudo dmesg \| head -n 5` | `Get-WinEvent` | Consulta los mensajes, advertencias y errores registrados por el núcleo y los servicios en el arranque actual. |
| **Listar módulos / drivers** | `lsmod`<br>`lsmod \| wc -l`<br>`modinfo dummy` | `driverquery`<br>`Get-CimInstance Win32_SystemDriver` | Lista los módulos del núcleo (`.ko.xz`) o controladores (`.sys`) que se ejecutan en modo núcleo. |
| **Cargar y descargar módulo** | `sudo modprobe dummy`<br>`sudo rmmod dummy` | *(Carga dinámica Plug and Play del sistema)* | "Contrata" y "despide" un módulo del núcleo en caliente (como la interfaz `dummy0`) sin reiniciar el sistema. |
| **Programar y cancelar parada** | `sudo shutdown -r +5 "Aviso"`<br>`sudo shutdown -c` | `shutdown /r /t 300 /c "Aviso"`<br>`shutdown /a` | Programa un reinicio ordenado con aviso a los usuarios y permite cancelarlo antes de que se ejecute. |
| **Inicio rápido y estado final** | `systemctl get-default`<br>`systemctl --failed` | `powercfg /a`<br>`(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power').HiberbootEnabled` | En Linux verifica el `target` por defecto y servicios fallidos; en Windows comprueba si el Inicio Rápido (`Hiberboot`) está activo. |
