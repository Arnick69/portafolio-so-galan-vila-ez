# 🪟 Ayuda Memoria de Comandos — Semana 4 (Llamadas al Sistema, Shell y Paquetes)

**Integrantes:** Nicolas Galán · Leonardo Vilanez  
**Asignatura:** Sistemas Operativos (EPN - FIEEC)

---

## 1. Rastreo de Llamadas al Sistema, Bibliotecas y Terminales (Taller 1 · Parte A)

| Acción / Propósito | Linux (Bash / AlmaLinux) | Windows (PowerShell) | Concepto Clave |
|---|---|---|---|
| Contar llamadas al sistema de un comando | `strace -c ls > /dev/null` | *Process Monitor* (Sysinternals, requiere Admin) | Resumen de llamadas (`strace -c`): cuenta invocaciones al núcleo sin medir tiempos reales. |
| Rastrear llamadas específicas (`openat`, `read`, `write`, `close`) | `strace -e trace=openat,read,write,close cat notas.txt` | *Process Monitor* con filtro por proceso | Flujo POSIX: abrir descriptor (`fd`), leer/escribir bloques y cerrar. |
| Ver bibliotecas compartidas de un binario | `ldd /bin/ls` | `(Get-Process -Id $PID).Modules \| Select-Object -First 8 ModuleName, FileName` | Bibliotecas dinámicas (`.so` en Linux, `.dll` en Windows) cargadas una vez en RAM. |
| Identificar biblioteca que ejecuta `syscall` | `ldd /bin/ls` (`libc.so.6`) | `(Get-Process -Id $PID).Modules \| Where-Object ModuleName -in 'ntdll.dll','KERNEL32.DLL','KERNELBASE.dll'` | Frontera usuario/núcleo: `libc.so.6` en Linux y `ntdll.dll` en Windows. |
| Verificar quién dibuja la terminal | `tty; ps -o comm= -p $PPID` | `Get-Process conhost, WindowsTerminal -ErrorAction SilentlyContinue \| Select-Object Name, Id` | Pseudoterminal (`/dev/pts/X`), consola del núcleo (`/dev/ttyX`) o proceso de usuario (`WindowsTerminal`/`conhost`). |

---

## 2. Costo por Llamada y Tamaño de Búfer (Taller 1 · Parte B)

| Acción / Propósito | Linux (Bash / AlmaLinux) | Windows (PowerShell) | Concepto Clave |
|---|---|---|---|
| Crear archivo de prueba de 1 MiB | `head -c 1048576 /dev/urandom > datos.bin` | `$b = New-Object byte[] 1MB; (New-Object Random 42).NextBytes($b); [IO.File]::WriteAllBytes($src, $b)` | Tamaño total $N = 1\text{ MiB}$ ($1\,048\,576\text{ bytes}$). |
| Medir copia por tamaño de bloque $B$ | `for bs in 1 16 512 4096 65536; do (time dd if=datos.bin of=copia.bin bs=$bs status=none) 2>&1 \| grep real; done` | `foreach ($B in 1, 16, 512, 4096, 65536) { [Ventanilla]::Copiar($src, $dst, $B) }` | $T \approx k \cdot \lceil N/B \rceil \cdot t_{\text{llamada}} + N \cdot t_{\text{byte}}$ con rendimientos decrecientes desde $B = 4096\text{ B}$. |
| Contar llamadas en copia ($k = 2$) | `strace -c dd if=peq.bin of=copia.bin bs=4096 status=none` | Cálculo directo $2 \cdot \lceil N/B \rceil$ (`Read` + `Write`) | Cada bloque copiado desde archivo requiere 1 `read` y 1 `write` ($k=2$). |
| Contar llamadas desde memoria ($k = 1$) | `strace -c -e trace=read,write python3 -c "import os; [os.write(1,b'x') for _ in range(65536)]" > /dev/null` | Escritura directa de arreglo en memoria con `FileStream.Write` | Si el dato ya está en RAM, solo se ejecuta `write` ($k=1$). |

---

## 3. Manejo de Errores, Códigos de Salida y Redirecciones (Taller 1 · Parte C y Taller 2 · Parte A)

| Acción / Propósito | Linux (Bash / AlmaLinux) | Windows (PowerShell) | Concepto Clave |
|---|---|---|---|
| Consultar código de salida y error por archivo inexistente | `cat noexiste.txt; echo $?` | `Get-Content noexiste.txt; $?` / `cmd /c type noexiste.txt; $LASTEXITCODE` | `errno` `ENOENT (2)` en Linux y código Win32 `2` en Windows; `$?` guarda estado. |
| Separar salida estándar (`1`) y errores (`2`) | `ls /etc /noexiste > salida.txt 2> errores.txt` | `Get-ChildItem C:\Windows, C:\NoExiste > salida.txt 2> errores.txt` | Descriptores estándar: `0` (`stdin`), `1` (`stdout`), `2` (`stderr`). |
| Unificar salida estándar y de errores | `ls /etc /noexiste > todo.txt 2>&1` | `Get-ChildItem C:\Windows, C:\NoExiste > todo.txt 2>&1` | `2>&1` redirige el canal de errores al mismo destino que `stdout`. |
| Top 3 procesos por consumo de RAM con tuberías | `ps -eo pid,comm,rss --sort=-rss \| head -n 4` | `Get-Process \| Sort-Object WS -Descending \| Select-Object -First 3 Name, Id, WS` | En Bash viaja texto plano; en PowerShell viajan objetos `.NET` tipados (`Int64`). |
| Ordenar números por valor numérico | `printf '999\n1000\n25\n' \| sort -n` | `999, 1000, 25 \| Sort-Object` | `sort` requiere `-n` para orden numérico; `Sort-Object` detecta el tipo `Int32`/`Int64`. |

---

## 4. Gestores de Paquetes: `dnf` y `winget` (Taller 2 · Parte B)

| Acción / Propósito | Linux (`dnf` / `rpm`) | Windows (`winget`) | Concepto Clave |
|---|---|---|---|
| Listar repositorios / orígenes configurados | `dnf repolist` | `winget source list` | Catálogo de proveedores y caché local de metadatos. |
| Consultar metadatos y ficha de un paquete | `dnf info jq` | `winget show jqlang.jq` | Versión, origen, descripción, publicador y hash SHA256. |
| Consultar dependencias de un paquete | `dnf repoquery --requires jq` / `rpm -qR jq` | `winget show jqlang.jq` | `jq` en Linux requiere `oniguruma` (`libonig.so.5`); en Windows es portable. |
| Instalar paquete desde repositorio oficial | `sudo dnf install -y jq` | `winget install --id jqlang.jq -e` | Descarga, verificación criptográfica e instalación automática. |
| Verificar firma GPG / huella SHA256 e historial | `rpm -qi jq \| grep Signature` y `dnf history` | `winget show jqlang.jq` y `winget list jq` | `dnf` valida firma GPG; `winget` valida el hash SHA256 del instalador. |
