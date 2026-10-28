# 💻 Portafolio de Sistemas Operativos - Semana 2

¡Hola! Bienvenidos a la segunda semana de nuestro portafolio de la materia **Sistemas Operativos**.

* **👨‍🎓 Estudiantes:** Nicolás Galán, Leonardo Vilañez
* **👨‍🏫 Docente:** Ing. Rubén Rumipamba, Ph.D.
* **🏫 Institución:** Escuela Politécnica Nacional (EPN - FIEEC)
* **🎯 Tema:** Jerarquía de Memoria, Caché y Representación de Datos

---

## 📌 ¿Qué encontrarás en esta carpeta?

En esta entrega hemos documentado y automatizado la inspección de la jerarquía de memoria (niveles de caché L1d, L1i, L2, L3, memoria RAM, Swap/Memoria Virtual y almacenamiento secundario) junto con el orden de bytes (*Endianness*) y el impacto de la localidad espacial en el rendimiento:

* 📝 **`Comandos.md`**: Ayuda memoria con la tabla comparativa de comandos entre Windows (PowerShell) y Linux (Bash) enfocados en memoria, caché, discos y volcados hexadecimales (`Format-Hex` / `xxd`).
* 🛠️ **`memoria.ps1`**: Script automatizado en PowerShell que consulta `Win32_CacheMemory`, `[BitConverter]::IsLittleEndian`, memoria RAM/Virtual y discos en Windows.
* 🐧 **`memoria.sh`**: Script automatizado en Bash que ejecuta `lscpu --caches`, calcula conjuntos L1d, audita `free -h` y mide tiempos de acceso en Linux.
* 📄 **`memoria_DESKTOP-FIEECEC.txt`**: Captura de salida generada por el script en el entorno Windows 11.
* 📄 **`memoria_fieecec-almalinux.txt`**: Captura de salida generada por el script en el entorno AlmaLinux.

---

## 📐 Conceptos y Fórmulas Clave

* **Cálculo de Conjuntos de Caché ($S$):**
  $$S = \frac{C}{L \times A}$$
  *En nuestro procesador:* $C = 49\,152\text{ bytes (48 KiB L1d)}$, $L = 64\text{ bytes}$, $A = 12\text{ vías} \implies S = 64\text{ conjuntos}$.
* **Tiempo Medio de Acceso a Memoria (AMAT):**
  $$T_{\text{medio}} = T_c + (1 - h) \cdot T_m$$
* **Principio de Localidad Espacial:** El recorrido de matrices en C por filas aprovecha las líneas contiguas de 64 bytes en caché ($h \approx 94\%$), superando ampliamente al recorrido por columnas ($h \approx 0\%$).
* **Orden de Bytes (Endianness):** Verificación de arquitectura *Little-Endian* en AMD64/x86_64 (el byte menos significativo se almacena en la dirección de memoria más baja).
* **Almacenamiento Rotacional:** Identificación mediante el parámetro `ROTA = 0` para unidades de estado sólido (SSD/NVMe) frente a `ROTA = 1` para discos mecánicos (HDD).
