# 🧠 Semana 02: Jerarquía de Memoria y Caché

![Semana](https://img.shields.io/badge/Semana-02-00F0FF?style=for-the-badge)
![Arquitectura](https://img.shields.io/badge/Arquitectura-x86__64%20%7C%20AMD64-FF0055?style=for-the-badge)
![Endian](https://img.shields.io/badge/Byte%20order-Little%20Endian-00FF66?style=for-the-badge)
![Estado](https://img.shields.io/badge/Build-Verificado-FCEE09?style=for-the-badge)

> **Análisis de rendimiento, niveles de caché, ordenamiento de bytes y localidad de datos**

| | |
|---|---|
| **Estudiantes** | Nicolas Galán · Leonardo Vilanez |
| **Docente** | Ing. Rubén Rumipamba, Ph.D. |
| **Institución** | EPN · FIEEC |

---

## 📖 Descripción

En esta semana exploramos cómo el procesador y el sistema operativo (Windows y Linux) organizan y consultan la jerarquía de memoria para reducir los tiempos de espera, cómo se direccionan los conjuntos en la caché y cómo se almacenan los datos a nivel de bytes.

## 📂 Contenido del repositorio

| Archivo | Tipo | Descripción |
|---|---|---|
| `Comandos.md` | Markdown | Tabla comparativa de comandos en **PowerShell** (Windows) y **Bash** (Linux) para inspeccionar memoria, caché, *endianness* y discos. |
| `memoria.ps1` | PowerShell | Script que consulta niveles de caché (`Win32_CacheMemory`), orden de bytes, RAM/Swap y discos físicos en Windows. |
| `memoria.sh` | Bash | Script que extrae la información de caché en Linux (`lscpu --caches`), calcula los conjuntos L1d y mide los tiempos de acceso matricial. |
| `memoria_DESKTOP-FIEECEC.txt` | Texto | Captura de resultados obtenidos en el entorno **Windows**. |
| `memoria_fieecec-almalinux.txt` | Texto | Captura de resultados obtenidos en el entorno **AlmaLinux**. |

## 💡 Conceptos clave

### La brecha CPU-Memoria y el Tiempo Medio de Acceso (AMAT)
El procesador opera en escalas de sub-nanosegundos, mientras que acceder a la memoria principal (RAM) toma decenas de nanosegundos. Para mitigar esta brecha se integran los niveles de caché **L1, L2 y L3**. El rendimiento efectivo de la jerarquía se mide con el **AMAT** (*Average Memory Access Time*):

$$\text{AMAT} = t_{\text{hit}} + (1 - h) \times t_{\text{penalización}}$$

| Símbolo | Significado | Ejemplo |
|---|---|---|
| $t_{\text{hit}}$ | Tiempo de acceso cuando el dato está en caché (acierto) | $1\text{ ns}$ |
| $h$ | Tasa de aciertos (*hit rate*) en la caché | $99\,\% = 0.99$ |
| $1 - h$ | Tasa de fallos (*miss rate*) | $1\,\% = 0.01$ |
| $t_{\text{penalización}}$ | Penalización de tiempo por ir a buscar el bloque a la RAM | $100\text{ ns}$ |

**Ejemplo:**
- Con $h = 95\,\%$: $\text{AMAT} = 1 + (0.05 \times 100) = \mathbf{6\text{ ns}}$
- Con $h = 99\,\%$: $\text{AMAT} = 1 + (0.01 \times 100) = \mathbf{2\text{ ns}}$ *(subir un 4 % de aciertos triplica la velocidad media de acceso y resulta $50\times$ más rápido que acceder directo a RAM).*

### Localidad espacial, temporal y orden de bytes
- **Localidad temporal:** si un dato se usa, es probable que se vuelva a usar pronto.
- **Localidad espacial:** si un dato se usa, es probable que sus direcciones vecinas también se usen pronto. Cuando ocurre un *cache miss*, la caché carga una **línea completa de 64 bytes**, razón por la cual recorrer una matriz en C **por filas** es drásticamente más rápido que recorrerla **por columnas**.
- **Little Endian (`x86_64`):** el byte menos significativo (LSB) se almacena en la dirección de memoria más baja.
- **Almacenamiento secundario:** distinción en el sistema operativo entre medios no rotacionales SSD/NVMe (`ROTA = 0`) y discos mecánicos HDD (`ROTA = 1`).

### Cálculo de conjuntos e índice en la caché L1d

El número de conjuntos $S$ y los bits de índice de una caché asociativa por conjuntos se obtienen con:

$$S = \frac{C}{L \times A} \qquad \text{y} \qquad b_{\text{índice}} = \log_2(S)$$

| Símbolo | Significado | Ejemplo |
|---|---|---|
| $C$ | Capacidad total de la caché L1d por núcleo | $48\text{ KiB} = 49\,152\text{ bytes}$ |
| $L$ | Tamaño de la línea de caché ($b_{\text{offset}} = \log_2(64) = 6\text{ bits}$) | $64\text{ bytes}$ |
| $A$ | Asociatividad (número de vías o *ways*) | $12\text{ vías}$ |

**Ejemplo:**

$$S = \frac{49\,152}{64 \times 12} = \frac{49\,152}{768} = \mathbf{64 \text{ conjuntos}} \implies b_{\text{índice}} = \log_2(64) = \mathbf{6 \text{ bits de índice}}$$

## 👥 Autores

- **Nicolas Galán**
- **Leonardo Vilanez**

---

<sub>Escuela Politécnica Nacional · Facultad de Ingeniería Eléctrica y Electrónica (FIEEC)</sub>
