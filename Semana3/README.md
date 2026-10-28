# ⚙️ Semana 03: Departamentos del SO, Multiprogramación y Arranque

![Semana](https://img.shields.io/badge/Semana-03-00F0FF?style=for-the-badge)
![Kernel](https://img.shields.io/badge/Kernel-NT%20%7C%20Linux-FF0055?style=for-the-badge)
![Init](https://img.shields.io/badge/Init-Systemd%20%7C%20Services-00FF66?style=for-the-badge)
![Estado](https://img.shields.io/badge/Build-Verificado-FCEE09?style=for-the-badge)

> **Medición de espera de E/S, grado de multiprogramación y diagnóstico de la secuencia de arranque**

| | |
|---|---|
| **Estudiantes** | Nicolas Galán · Leonardo Vilanez |
| **Docente** | Ing. Rubén Rumipamba, Ph.D. |
| **Institución** | EPN · FIEEC |

---

## 📖 Descripción

En esta semana estudiamos los departamentos fundamentales del sistema operativo (gestión de procesos, memoria, archivos y entrada/salida), modelamos matemáticamente cómo la multiprogramación aprovecha los tiempos de espera de E/S y auditamos la secuencia completa de arranque en Windows y Linux.

## 📂 Contenido del repositorio

| Archivo | Tipo | Descripción |
|---|---|---|
| `Comandos.md` | Markdown | Tabla comparativa de comandos en **PowerShell** y **Bash** para auditar procesos, servicios, módulos del kernel y tiempos de inicio. |
| `informe_arranque.ps1` | PowerShell | Script de 6 secciones que inspecciona el último arranque, servicios activos, controladores `.sys` e inicio rápido en Windows. |
| `informe_arranque.sh` | Bash | Script de 6 secciones que ejecuta `systemd-analyze` (`time`, `blame`, `critical-chain`), audita servicios fallidos y lista módulos con `lsmod`. |
| `informe_arranque_DESKTOP-FIEECEC.txt` | Texto | Captura del informe de arranque generado en **Windows 11 Pro**. |
| `informe_arranque_fieecec-almalinux.txt` | Texto | Captura del informe de arranque generado en **AlmaLinux**. |

## 💡 Conceptos clave

### Fracción de espera de E/S ($p$) y clasificación de procesos
Un proceso alterna entre ráfagas de cálculo en CPU y esperas de Entrada/Salida (disco, red, teclado). A partir de los tiempos de ejecución medidos (`real`, `user` y `sys`), la fracción de tiempo que el proceso pasa esperando E/S se calcula como:

$$p = 1 - \frac{t_{\text{user}} + t_{\text{sys}}}{t_{\text{real}}}$$

| Tipo de programa | $p$ medido (Linux) | $p$ medido (Windows) | Clasificación |
|---|---|---|---|
| **Espera un dispositivo (`read` / `ping`)** | $1.000$ | $0.993$ | **Limitado por E/S** (*I/O-bound*, $p \approx 1$) |
| **Cálculo intensivo (bucle aritmético)** | $0.004$ | $0.013$ | **Limitado por CPU** (*CPU-bound*, $p \approx 0$) |
| **Búsqueda en disco (`find` / `dir`)** | $0.543$ | $0.630$ | **Mixto / E/S** |

### Modelo de multiprogramación y utilización de la CPU

Si un proceso tiene una probabilidad $p$ de estar esperando E/S, con $n$ procesos cargados simultáneamente en memoria (grado de multiprogramación), la probabilidad de que **todos** estén esperando al mismo tiempo es $p^n$. Por tanto, la utilización de la CPU ($U$) y el número de procesos necesarios para alcanzar una meta son:

$$U = 1 - p^n \qquad \text{y} \qquad n \ge \left\lceil \frac{\ln(1 - U)}{\ln(p)} \right\rceil$$

| Símbolo | Significado | Ejemplo |
|---|---|---|
| $p$ | Fracción del tiempo que cada proceso espera por E/S | $0.80\text{ (80 % en espera)}$ |
| $n$ | Grado de multiprogramación (procesos simultáneos en RAM) | $11\text{ procesos}$ |
| $p^n$ | Fracción del tiempo en que la CPU queda ociosa | $0.80^{11} \approx 0.0859\text{ (8.6 %)}$ |
| $U$ | Utilización efectiva de la CPU | $\ge 90\,\%\text{ (0.90)}$ |

### Capacidad de la memoria RAM («La Mesada»)

El número máximo de procesos que caben en memoria física sin recurrir a paginación intensiva (*swapping*) está limitado por la RAM disponible tras descontar el sistema operativo:

$$n_{\max} = \left\lfloor \frac{\text{RAM}_{\text{total}} - \text{RAM}_{\text{SO}}}{\text{Tamaño}_{\text{proceso}}} \right\rfloor$$

**Ejemplo integrador (Laboratorio):**
- **Escenario con $16\text{ GiB}$ de RAM ($\text{SO} = 4\text{ GiB}$, Proceso $= 1\text{ GiB}$, $p = 0.90$):**
  1. Procesos que caben en la mesada: $n_{\max} = \left\lfloor \frac{16 - 4}{1} \right\rfloor = \mathbf{12\text{ procesos}}$.
  2. Utilización efectiva con esos 12 procesos: $U = 1 - 0.90^{12} = \mathbf{71.8\,\%}$.
  3. Procesos requeridos para lograr $U \ge 90\,\%$: $n = \left\lceil \frac{\ln(1 - 0.90)}{\ln(0.90)} \right\rceil = \mathbf{22\text{ procesos}}$.
  4. RAM total necesaria para sostener esos 22 procesos: $4\text{ GiB} + (22 \times 1\text{ GiB}) = \mathbf{26\text{ GiB}}$.

### Secuencia de arranque y procesos raíz
1. **Firmware (UEFI / BIOS):** autoprueba de hardware (POST) e inicialización.
2. **Gestor de arranque:** `GRUB2` en Linux / `Windows Boot Manager` en Windows.
3. **Núcleo e imagen inicial:** carga de `vmlinuz` + `initramfs` en Linux / `ntoskrnl.exe` + controladores `.sys` en Windows.
4. **Proceso inicial del sistema:** `systemd` (**PID 1**) en GNU/Linux y `System` (**PID 4**) junto con `smss.exe` / `services.exe` en Windows.

## 👥 Autores

- **Nicolas Galán**
- **Leonardo Vilanez**

---

<sub>Escuela Politécnica Nacional · Facultad de Ingeniería Eléctrica y Electrónica (FIEEC)</sub>
