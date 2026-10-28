# 🪟 Semana 04: Llamadas al Sistema, Shell y Gestores de Paquetes

![Semana](https://img.shields.io/badge/Semana-04-00F0FF?style=for-the-badge)
![API](https://img.shields.io/badge/API-POSIX%20%7C%20Win32-FF0055?style=for-the-badge)
![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20PowerShell-00FF66?style=for-the-badge)
![Estado](https://img.shields.io/badge/Build-Verificado-FCEE09?style=for-the-badge)

> **La ventanilla del núcleo: llamadas al sistema, costo de búfer, tuberías en el shell y gestores de paquetes**

| | |
|---|---|
| **Estudiantes** | Nicolas Galán · Leonardo Vilanez |
| **Docente** | Ing. Rubén Rumipamba, Ph.D. |
| **Institución** | EPN · FIEEC |

---

## 📖 Descripción

En esta semana estudiamos cómo los programas en modo usuario solicitan servicios protegidos al núcleo mediante llamadas al sistema (en los estándares **POSIX** y **Win32**), cómo el uso de búferes reduce el costo fijo de cruzar al modo núcleo, cómo el intérprete de comandos (**Bash** y **PowerShell**) traduce órdenes y conecta programas, y cómo los gestores de paquetes (**`dnf`** y **`winget`**) instalan software verificando dependencias y firmas criptográficas.

## 📂 Contenido del repositorio

| Archivo | Tipo | Descripción |
|---|---|---|
| `Comandos.md` | Markdown | Tabla comparativa de comandos en **PowerShell** (Windows) y **Bash** (Linux) para rastreo de llamadas (`strace`), tuberías, redirecciones y gestores de paquetes (`dnf` / `winget`). |
| `verificador_entorno.ps1` | PowerShell | Script de 6 secciones que audita el sistema, versión de PowerShell, herramientas instaladas, orígenes de paquetes (`winget`), últimas 5 instalaciones y dependencias faltantes. |
| `verificador_entorno.sh` | Bash | Script de 6 secciones que audita el SO (`/etc/os-release`), versión de Bash, herramientas con `command -v`, repositorios (`dnf repolist`), historial (`dnf history`) y código de salida (`exit 0` / `exit 1`). |
| `verificador_entorno_DESKTOP-FIEECEC.txt` | Texto | Captura de resultados obtenidos en el entorno **Windows**. |
| `verificador_entorno_fieecec-almalinux.txt` | Texto | Captura de resultados obtenidos en el entorno **AlmaLinux**. |

## 🚀 Cómo ejecutar

**Windows (PowerShell):**
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\verificador_entorno.ps1
