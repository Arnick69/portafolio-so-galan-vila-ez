# 💻 Semana 01: Arquitectura e Inventario de Hardware

![Semana](https://img.shields.io/badge/Semana-01-00F0FF?style=for-the-badge)
![Arquitectura](https://img.shields.io/badge/Arquitectura-Von_Neumann-FF0055?style=for-the-badge)
![Entorno](https://img.shields.io/badge/Shell-PowerShell%20%7C%20Bash-00FF66?style=for-the-badge)
![Estado](https://img.shields.io/badge/Build-Verificado-FCEE09?style=for-the-badge)

> **Arquitectura del computador, métricas de rendimiento de CPU y recolección automatizada de hardware**

| | |
|---|---|
| **Estudiantes** | Nicolas Galán · Leonardo Vilanez |
| **Docente** | Ing. Rubén Rumipamba, Ph.D. |
| **Institución** | EPN · FIEEC |

---

## 📖 Descripción

En esta primera semana analizamos los componentes fundamentales de la arquitectura de un computador (CPU, memoria, buses y entrada/salida), las ecuaciones que rigen el rendimiento del procesador y la automatización del inventario de hardware tanto en Windows como en Linux.

## 📂 Contenido del repositorio

| Archivo | Tipo | Descripción |
|---|---|---|
| `Comandos.md` | Markdown | Tabla comparativa de comandos en **PowerShell** y **Bash** para inspeccionar CPU, RAM, discos y flujo básico de Git. |
| `inventario.ps1` | PowerShell | Script que consulta procesador, memoria visible y unidades de almacenamiento en Windows mediante `CIM/WMI`. |
| `inventario.sh` | Bash | Script que extrae métricas de CPU (`lscpu`), memoria (`free -h`) y bloques de disco (`lsblk`) en Linux. |
| `inventario_DESKTOP.txt` | Texto | Captura de resultados generada en el entorno **Windows**. |
| `inventario_linux.txt` | Texto | Captura de resultados generada en el entorno **AlmaLinux**. |

## 💡 Conceptos clave

### Modelo de Von Neumann y registros del procesador
El ciclo de instrucción (*fetch-decode-execute*) coordina el flujo de datos e instrucciones a través de cuatro registros esenciales:
- **PC (*Program Counter*):** contiene la dirección de memoria de la **próxima instrucción** a ejecutar.
- **MAR (*Memory Address Register*):** almacena la dirección de memoria que se va a leer o escribir.
- **MBR (*Memory Buffer Register*):** contiene el dato o instrucción leído desde la memoria (o listo para escribirse en ella).
- **IR (*Instruction Register*):** guarda la instrucción actual mientras la unidad de control la decodifica.

### Ecuación del rendimiento de la CPU

El tiempo total de ejecución de un programa en la CPU ($T_{\text{CPU}}$) depende de tres factores:

$$T_{\text{CPU}} = \text{IC} \times \text{CPI} \times T_c = \frac{\text{IC} \times \text{CPI}}{f}$$

| Símbolo | Significado | Ejemplo |
|---|---|---|
| $\text{IC}$ | Número de instrucciones ejecutadas (*Instruction Count*) | $10^9\text{ instrucciones}$ |
| $\text{CPI}$ | Ciclos promedio por instrucción ($\sum \text{CPI}_i \times \text{frecuencia}_i$) | $1.7\text{ ciclos/instrucción}$ |
| $f$ | Frecuencia de reloj del procesador ($T_c = 1/f$) | $3\text{ GHz} = 3 \times 10^9\text{ Hz}$ ($T_c \approx 0.33\text{ ns}$) |
| $\text{MIPS}$ | Millones de instrucciones por segundo: $\frac{f}{\text{CPI} \times 10^6}$ | $\frac{3000}{1.7} \approx 1765\text{ MIPS}$ |

**Ejemplo comparativo (¿Más GHz significa mucho más rápido?):**
- **CPU A ($3\text{ GHz}$, $\text{CPI} = 1.7$):** $T_A = \frac{10^9 \times 1.7}{3 \times 10^9} = 0.567\text{ s}$
- **CPU B ($4\text{ GHz}$, $\text{CPI} = 2.2$):** $T_B = \frac{10^9 \times 2.2}{4 \times 10^9} = 0.550\text{ s}$
- Aunque la CPU B tiene un **33 % más de frecuencia**, su mayor $\text{CPI}$ hace que la mejora real sea de apenas $\frac{0.567}{0.550} \approx \mathbf{1.03\times}$.

### Ley de Amdahl

El incremento de velocidad (*Speedup*) al mejorar o paralelizar una fracción del sistema está limitado por la parte secuencial que no se puede mejorar:

$$\text{Speedup} = \frac{1}{(1 - f) + \frac{f}{S}}$$

| Símbolo | Significado | Ejemplo |
|---|---|---|
| $f$ | Fracción del tiempo de ejecución que es mejorable o paralelizable | $0.80\text{ (80 %)}$ |
| $1 - f$ | Fracción secuencial (no mejorable) | $0.20\text{ (20 %)}$ |
| $S\text{ (o }N\text{)}$ | Factor de mejora o número de núcleos de procesamiento | $8\text{ núcleos}$ |

**Ejemplo:**

$$\text{Speedup}_{(N=8)} = \frac{1}{(1 - 0.80) + \frac{0.80}{8}} = \frac{1}{0.20 + 0.10} = \mathbf{3.33\times}$$

$$\text{Speedup}_{\max\,(N \to \infty)} = \frac{1}{1 - 0.80} = \mathbf{5\times \text{ (límite teórico)}}$$

## 👥 Autores

- **Nicolas Galán**
- **Leonardo Vilanez**

---

<sub>Escuela Politécnica Nacional · Facultad de Ingeniería Eléctrica y Electrónica (FIEEC)</sub>
