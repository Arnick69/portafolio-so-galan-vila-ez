# ====================================================================
#    SEMANA 05: SEGURIDAD, PRIVILEGIOS, CORTAFUEGOS Y AUDITORIA
# ====================================================================

Bienvenido al modulo de la **Semana 5**. En esta seccion documentamos la
implementacion practica de los mecanismos de seguridad del Sistema Operativo
en **Windows (PowerShell)** y **GNU/Linux (AlmaLinux 10 - Bash)**: control de
identidad y privilegios (`UID`/`SID`, `sudoers`, `UAC`), inspeccion de puertos
en escucha, filtrado de red (`firewalld`/`nftables` vs `Windows Defender Firewall`/`WFP`)
y analisis de bitacoras de autenticacion (`journald`/SSH y Eventos `4625`).

+--------------------------------------------------------------------+
| DATOS DE LA ENTREGA - SEMANA 05 (DEBER 5)                          |
+--------------------------------------------------------------------+
| [*] Estudiantes : Nicolas Galan, Leonardo Vilanez                  |
| [*] Docente     : Ing. Ruben Rumipamba, Ph.D.                      |
| [*] Materia     : Sistemas Operativos (EPN - FIEEC)                |
| [*] Carpeta     : /semana05                                        |
+--------------------------------------------------------------------+

---

## [1] MAPA DE ARCHIVOS ENTREGABLES

| Archivo | Tipo | Descripcion Tecnica |
| :--- | :--- | :--- |
| **[`README.md`](./README.md)** | `Markdown (.md)` | Documentacion general del modulo, arquitectura de la auditoria y declaracion de uso de IA. |
| **[`Comandos.md`](./Comandos.md)** | `Markdown (.md)` | Ayuda memoria con las tablas comparativas Windows vs Linux de redes, cortafuegos, identidad y bitacoras. |
| **[`auditoria_seguridad.ps1`](./auditoria_seguridad.ps1)** | `PowerShell (.ps1)` | Script de auditoria en Windows: cuentas Administradores (`S-1-5-32-544`), puertos en escucha, perfiles Firewall, eventos `4625` y veredicto. |
| **[`auditoria_seguridad.sh`](./auditoria_seguridad.sh)** | `Bash (.sh)` | Script de auditoria en Linux: cuentas `UID 0` y grupo `wheel`, puertos `ss -H -tln`, estado de `firewalld`, fallos SSH y veredicto. |
| **[`auditoria_DESKTOP-FIEECEC.txt`](./auditoria_DESKTOP-FIEECEC.txt)** | `Texto (.txt)` | Reporte de salida generado por `auditoria_seguridad.ps1` sobre muestras de eventos `4625` y estado del equipo Windows. |
| **[`auditoria_almalinux-vm.txt`](./auditoria_almalinux-vm.txt)** | `Texto (.txt)` | Reporte de salida generado por `auditoria_seguridad.sh` sobre `muestras_auth.log` y estado de la VM AlmaLinux. |

---

## [2] ARQUITECTURA DEL SCRIPT DE AUDITORIA (DEBER 5)

Ambos scripts evaluan cinco controles criticos sin requerir privilegios de administrador o `root` en tiempo de ejecucion, devolviendo un codigo de salida estandar (`0` = `OK`, `1` = `ALERTA`):

1. **Seccion 1 - Llavero Maestro:** Verifica cuentas con `UID 0` distintas de `root` y miembros de `wheel` en Linux; en Windows audita el grupo `S-1-5-32-544` y alerta si la cuenta integrada `...-500` esta habilitada.
2. **Seccion 2 - Puertas Abiertas:** Inspecciona puertos TCP en escucha expuestos a la red (`0.0.0.0` / `::`) y alerta si detecta servicios inseguros (`21`, `23`, `3306`, `3389`, `5900`).
3. **Seccion 3 - Portero Activo:** Comprueba que `firewalld` este en estado `active` (Linux) y que los perfiles `Domain`, `Private` y `Public` de Windows Defender Firewall esten habilitados.
4. **Seccion 4 - Intentos Fallidos (IDS):** Contabiliza fallos de autenticacion por direccion IP (`Failed password` por SSH en Linux y eventos `4625` en Windows), alertando si alguna IP alcanza el umbral configurado (`5` por defecto).
5. **Seccion 5 - Veredicto Final:** Consolida el estado de las cuatro secciones y retorna el codigo de salida correspondiente al sistema operativo.

---

## [3] DECLARACION DE USO ETICO DE IA (SEMANA 05)

En cumplimiento con las normas academicas de la asignatura, se declara el uso de Inteligencia Artificial como herramienta de apoyo para la estructuracion modular de funciones en Bash y PowerShell, el manejo de expresiones regulares en el analisis de bitacoras (`awk` y `Import-Csv`) y la validacion de formato Markdown. Todo el codigo fue probado y verificado por ambos integrantes.

* **[Prompt 1 - Implementacion del Deber 5]:**
  *"Ayudame a estructurar las 5 funciones de auditoria de seguridad en Bash y PowerShell sin requerir sudo ni administrador, soportando lectura de bitacoras de muestra mediante parametros."*
* **[Prompt 2 - Documentacion Comparativa]:**
  *"Genera una tabla comparativa formal en Markdown entre los comandos de red, cortafuegos, identidad y bitacoras vistos en los Talleres 1 y 2 de la Semana 5."*

---
*[EPN - Sistemas Operativos | Repositorio mantenido por N. Galan & L. Vilanez]*
