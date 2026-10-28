# 💻 Portafolio de Sistemas Operativos - Semana 1

¡Hola! Bienvenidos a nuestro portafolio de la primera semana de la materia **Sistemas Operativos**.

* **👨‍🎓 Estudiantes:** Nicolás Galán, Leonardo Vilañez
* **👨‍🏫 Docente:** Ing. Rubén Rumipamba, Ph.D.
* **🏫 Institución:** Escuela Politécnica Nacional (EPN - FIEEC)
* **🎯 Tema:** Arquitectura de Computadoras e Inventario de Hardware

---

## 📌 ¿Qué encontrarás en esta carpeta?

En esta carpeta hemos documentado y automatizado la recolección de información sobre el hardware, basándonos en los conceptos de arquitectura (CPU, Memoria, E/S y Buses) vistos en la primera semana de clases:

* 📝 **`Comandos.md`**: Ayuda memoria estructurada que incluye la tabla comparativa de comandos entre Windows (PowerShell) y Linux (Bash), comandos esenciales de Git/GitHub y comandos de inspección a bajo nivel.
* 🛠️ **`inventario.ps1`**: Script automatizado en PowerShell diseñado para recolectar las métricas clave de hardware en un entorno Windows.
* 🐧 **`inventario.sh`**: Script automatizado en Bash para realizar la misma tarea de inventario dentro de un entorno Linux.
* 📄 **`inventario_DESKTOP.txt`**: Captura de los resultados generados por el script de Windows (datos obtenidos de la máquina local).
* 📄 **`inventario_linux.txt`**: Captura de los resultados generados por el script de Linux (datos obtenidos del entorno Linux).

---

## 📐 Conceptos y Fórmulas Clave

* **Rendimiento de la CPU (Tiempo de Ejecución):**
  $$T = \text{IC} \times \text{CPI} \times T_c = \frac{\text{IC} \times \text{CPI}}{f}$$
* **Ley de Amdahl (Aceleración por paralelización):**
  $$\text{Speedup} = \frac{1}{(1 - f_p) + \frac{f_p}{N}}$$
* **Modelo Von Neumann:** Ciclo de instrucción estructurado con registros PC (*Program Counter*), IR (*Instruction Register*), MAR (*Memory Address Register*) y MBR (*Memory Buffer Register*).
* **Capacidad de Direccionamiento:** Con $n$ bits en el bus de direcciones se direccionan exactamente $2^n$ posiciones de memoria.

---

## 🖥️ Resumen del Hardware Analizado

### Entorno Windows
* **Equipo:** DESKTOP-FIEECEC
* **Sistema Operativo:** Microsoft Windows 11 Pro (64-bit)
* **Procesador:** Intel(R) Core(TM) i7-11800H @ 2.30GHz (8 núcleos, 16 hilos)
* **Memoria RAM:** 15.8 GB
* **Almacenamiento:** Unidad SSD NVMe

### Entorno Linux (Máquina Virtual / AlmaLinux)
* **Equipo / Host:** fieecec-almalinux
* **Sistema Operativo:** AlmaLinux 9.4 (Seafoam Ocelot) / Linux x86_64
* **Cachés de CPU:** L1d (192 KiB), L1i (128 KiB), L2 (5 MiB), L3 (12 MiB)
* **Memoria RAM:** 7.7 GiB asignados
