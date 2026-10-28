# 🧠 Semana 02: Jerarquía de Memoria y Caché

![Semana](https://img.shields.io/badge/Semana-02-00F0FF?style=for-the-badge)
![Arquitectura](https://img.shields.io/badge/Arquitectura-x86__64%20%7C%20AMD64-FF0055?style=for-the-badge)
![Endian](https://img.shields.io/badge/Byte%20order-Little%20Endian-00FF66?style=for-the-badge)
![Estado](https://img.shields.io/badge/Build-Verificado-FCEE09?style=for-the-badge)

> **Análisis de rendimiento, caché y localidad de datos**

| | |
|---|---|
| **Estudiantes** | Nicolas Galán · Leonardo Vilanez |
| **Docente** | Ing. Rubén Rumipamba, Ph.D. |
| **Institución** | EPN · FIEEC |

---

## 📖 Descripción

En esta semana exploramos cómo el procesador y el sistema operativo (Windows y Linux) organizan y consultan la memoria para reducir los tiempos de espera.

## 📂 Contenido del repositorio

| Archivo | Tipo | Descripción |
|---|---|---|
| `Comandos.md` | Markdown | Tabla comparativa de comandos en **PowerShell** (Windows) y **Bash** (Linux) para inspeccionar memoria, caché y discos. |
| `memoria.ps1` | PowerShell | Script que consulta niveles de caché, RAM y discos físicos en Windows. |
| `memoria.sh` | Bash | Script que extrae la información de caché en Linux, calcula los conjuntos L1d y mide los tiempos de la matriz. |
| `memoria_DESKTOP-FIEECEC.txt` | Texto | Captura de resultados obtenidos en el entorno **Windows**. |
| `memoria_fieecec-almalinux.txt` | Texto | Captura de resultados obtenidos en el entorno **AlmaLinux**. |

## 🚀 Cómo ejecutar

**Windows (PowerShell):**
```powershell
.\memoria.ps1
```

**Linux (Bash):**
```bash
chmod +x memoria.sh
./memoria.sh
```

Para consultar los comandos de forma manual, revisa [`Comandos.md`](./Comandos.md).

## 💡 Conceptos clave

### La brecha CPU-Memoria
El procesador es mucho más rápido que la memoria principal (RAM), y esperar a la RAM consume muchos ciclos. Por eso existen los niveles de caché **L1, L2 y L3**, cada vez más grandes y lentos, ubicados cada vez más lejos del núcleo.

### Localidad espacial y temporal
- **Localidad temporal:** si un dato se usa, es probable que se vuelva a usar pronto.
- **Localidad espacial:** si un dato se usa, es probable que sus vecinos también se usen.

Cuando ocurre un *cache miss*, la caché no trae solo el dato pedido sino una **línea completa de 64 bytes**. Por eso recorrer una matriz **por filas** (datos contiguos en memoria) es mucho más rápido que recorrerla **por columnas**.

### Cálculo de conjuntos en la caché L1d

El número de conjuntos $S$ de una caché se obtiene con:

$$S = \frac{C}{L \times A}$$

| Símbolo | Significado | Ejemplo |
|---|---|---|
| $C$ | Capacidad total de la caché | $48\text{ KiB} = 49\,152\text{ bytes}$ |
| $L$ | Tamaño de la línea de caché | $64\text{ bytes}$ |
| $A$ | Asociatividad (número de vías o *ways*) | $12$ |

**Ejemplo:**

$$S = \frac{49\,152}{64 \times 12} = \frac{49\,152}{768} = 64 \text{ conjuntos}$$

## 👥 Autores

- **Nicolas Galán**
- **Leonardo Vilanez**

---

<sub>Escuela Politécnica Nacional · Facultad de Ingeniería Eléctrica y Electrónica (FIEEC)</sub>
