# ====================================================================
#    AYUDA MEMORIA DE COMANDOS - SEMANA 05 (WINDOWS VS LINUX)
# ====================================================================

Comparativa tecnica de comandos de administracion de seguridad, red,
cortafuegos, identidad de usuarios y analisis de bitacoras entre
**Windows (PowerShell)** y **GNU/Linux (AlmaLinux / Bash)**.

---

## [1] PUERTOS EN ESCUCHA Y SERVICIOS DE RED (TALLER 1 - PARTE A)

| Operacion | Windows (PowerShell) | Linux (Bash) | Descripcion Tecnica |
| :--- | :--- | :--- | :--- |
| Listar puertos TCP en escucha | `Get-NetTCPConnection -State Listen` | `ss -tln` | Muestra direcciones locales y puertos abiertos esperando conexiones TCP. |
| Identificar proceso propietario | `Get-Process -Id <PID>` | `sudo ss -tlnp` | Asocia cada puerto en escucha con el PID y nombre del proceso que lo atiende. |
| Levantar servidor web de prueba | `python -m http.server 8080` | `python3 -m http.server 8080 &` | Inicia un servicio HTTP local en el puerto `8080` para pruebas de conectividad. |
| Consultar codigo de respuesta HTTP | `Invoke-WebRequest http://127.0.0.1:8080` | `curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8080` | Comprueba si un puerto responde correctamente (`200 OK`) sin descargar el cuerpo. |

---

## [2] CORTAFUEGOS Y MOTOR DE FILTRADO (TALLER 1 - PARTE B)

| Operacion | Windows (PowerShell) | Linux (Bash) | Descripcion Tecnica |
| :--- | :--- | :--- | :--- |
| Verificar estado del cortafuegos | `Get-NetFirewallProfile \| Select Name, Enabled` | `sudo firewall-cmd --state` | Comprueba si el servicio de cortafuegos esta activo y que perfiles aplica. |
| Listar reglas y servicios permitidos | `Get-NetFirewallRule -Enabled True -Direction Inbound` | `sudo firewall-cmd --list-all` | Muestra la configuracion activa de zonas, interfaces y reglas de entrada. |
| Inspeccionar motor en el nucleo | `Get-Service mpssvc, BFE` / `netsh wfp show filters` | `sudo nft list tables` / `sudo nft list table inet firewalld` | Consulta la capa de filtrado del kernel (`WFP`/`BFE` en Windows, `nftables` en Linux). |
| Bloquear puerto entrante | `New-NetFirewallRule -DisplayName 'Taller5' -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Block` | `sudo nft add rule inet taller entrada tcp dport 8080 drop` | Crea una regla explicita para descartar o bloquear paquetes hacia el puerto `8080`. |
| Eliminar regla de prueba | `Remove-NetFirewallRule -DisplayName 'Taller5'` | `sudo nft delete table inet taller` | Limpia las reglas temporales para restaurar el comportamiento normal de red. |

---

## [3] IDENTIDAD, PRIVILEGIOS Y ELEVACION (TALLER 2 - PARTES A Y B)

| Operacion | Windows (PowerShell) | Linux (Bash) | Descripcion Tecnica |
| :--- | :--- | :--- | :--- |
| Ver identificador numerico de cuenta | `whoami /user` | `id` | Muestra el `SID` (y `RID`) en Windows o el `UID` y `GID` en Linux. |
| Ver grupos y nivel de integridad | `whoami /groups` | `id` / `getent group wheel` | Lista los grupos asignados y el nivel de integridad (`Medio` vs `Alto` por UAC). |
| Listar cuentas con llavero maestro | `Get-LocalGroupMember -SID 'S-1-5-32-544'` | `awk -F: '$3==0 {print $1}' /etc/passwd` | Identifica cuentas con privilegios totales (`Administradores` por SID universal y `UID 0`). |
| Consultar privilegios asignados | `whoami /priv` | `sudo -l` | Muestra los derechos del token en Windows o los comandos permitidos en `sudoers`. |
| Solicitar elevacion de privilegios | `Start-Process powershell -Verb RunAs` | `sudo <comando>` | Solicita elevacion temporal mediante `UAC` (token dividido) o `sudo`. |
| Inspeccionar archivo de claves | `icacls C:\Windows\System32\config\SAM` | `ls -l /etc/shadow` | Verifica permisos de acceso sobre el almacen de credenciales del sistema. |

---

## [4] BITACORAS Y DETECCION DE INTRUSOS (IDS MANUAL)

| Operacion | Windows (PowerShell) | Linux (Bash) | Descripcion Tecnica |
| :--- | :--- | :--- | :--- |
| Consultar eventos fallidos en vivo | `Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625}` | `journalctl -u sshd --since '10 min ago' \| grep -E 'Failed\|Invalid'` | Filtra registros de autenticacion fallida (`Evento 4625` o `Failed password` en SSH). |
| Consultar bitacora de uso de privilegios | `Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4672}` | `journalctl -t sudo -n 5 --no-pager` | Audita el inicio de sesiones privilegiadas o intentos no autorizados de `sudo`. |
| Contar fallos por IP desde muestra | `Import-Csv .\muestras_eventos_4625.csv \| Where-Object Id -eq '4625' \| Group-Object IpAddress \| Sort-Object Count -Descending` | `grep 'Failed password' muestras_auth.log \| awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' \| sort \| uniq -c \| sort -rn` | Agrupa los intentos fallidos por direccion IP de origen para detectar ataques de fuerza bruta. |
