# Comandos de Seguridad (Semana 5)

| Descripción de la Acción | Windows (PowerShell) | Linux (Bash) |
| :--- | :--- | :--- |
| Ver puertos en escucha | `Get-NetTCPConnection -State Listen` | `ss -tln` |
| Ver estado del cortafuegos | `Get-NetFirewallProfile` | `firewall-cmd --list-all` |
| Identidad del usuario (UID/SID y grupos) | `whoami /user` y `whoami /groups` | `id` |
| Consultar llavero maestro (Administradores/UID 0) | `Get-LocalGroupMember -SID S-1-5-32-544` | `awk -F: '$3==0' /etc/passwd` |
| Consultar bitácora de inicios de sesión fallidos | `Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625}` | `journalctl -u sshd \| grep Failed` |
