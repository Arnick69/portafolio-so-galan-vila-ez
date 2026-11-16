# Semana 5: Auditoría de Seguridad del Equipo

Esta carpeta contiene los scripts y evidencias de las actividades de la Semana 5 de Sistemas Operativos, correspondientes al **Deber 5**. Los temas principales cubren mecanismos de seguridad: puertos, cortafuegos (firewalld / Windows Defender), autenticación, autorización (sudo / UAC) y auditoría (logs y Visor de Eventos).

## Contenido de la carpeta

* `ayuda_memoria.md`: Resumen de los comandos de Linux y PowerShell utilizados durante la semana para revisar seguridad y accesos.
* `auditoria_seguridad.sh`: Script en Bash que automatiza la revisión de seguridad en AlmaLinux (UID 0, puertos abiertos, estado del cortafuegos, intentos fallidos por SSH).
* `auditoria_seguridad.ps1`: Script en PowerShell que realiza la misma auditoría en Windows (Grupo de Administradores, puertos en escucha, estado de los perfiles del firewall, intentos fallidos de inicio de sesión).
* `salida_linux.txt`: Captura de la ejecución del script `.sh`.
* `salida_windows.txt`: Captura de la ejecución del script `.ps1`.

## Ejecución de los scripts

**Para Linux (AlmaLinux):**
Asignar permisos de ejecución y correr el script:
```bash
chmod +x auditoria_seguridad.sh
./auditoria_seguridad.sh
