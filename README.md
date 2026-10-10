# Portafolio Sistemas Operativos - Semana 1
**Estudiante:** Galán Vila  
**Materia:** Sistemas Operativos  
**Docente:** Rubén Rumipamba  
**Tema:** Arquitectura de Computadoras e Inventario de Hardware

---

## 1. Descripción de los Entregables

En esta carpeta se encuentran los archivos correspondientes a las actividades y al Deber 1 de la Semana 1:

* **`Comandos.md`**: Ayuda memoria con comandos comparativos entre Windows (PowerShell) y Linux (Bash), comandos de Git/GitHub y comandos de bajo nivel.
* **`inventario.ps1`**: Script automatizado en PowerShell para la recolección de métricas de hardware en entorno Windows.
* **`inventario.sh`**: Script automatizado en Bash para la recolección de métricas de hardware en entorno Linux.
* **`inventario_DESKTOP.txt`**: Captura de salida generada por el script de Windows con los datos del equipo local.
* **`inventario_linux.txt`**: Captura de salida generada por el script de Linux con los datos del subsistema Linux/WSL.

---

## 2. Resumen de Hardware Identificado

### Entorno Windows
* **Equipo:** DESKTOP-FIEECEC
* **Sistema Operativo:** Microsoft Windows 11 Pro (64-bit)
* **Procesador:** Intel(R) Core(TM) i7-11800H @ 2.30GHz (8 núcleos, 16 hilos)
* **Memoria RAM:** 15.8 GB
* **Almacenamiento:** Unidad SSD NVMe

### Entorno Linux (WSL / Máquina Virtual)
* **Equipo / Host:** fieecec-linux
* **Sistema Operativo:** Red Hat Enterprise Linux / Linux x86_64
* **Cachés de CPU:** L1d (192 KiB), L1i (128 KiB), L2 (5 MiB), L3 (12 MiB)
* **Memoria RAM:** 7.7 GiB asignados

---

## 3. Instrucciones de Ejecución

### Ejecución en Windows (PowerShell)
```powershell
.\inventario.ps1
