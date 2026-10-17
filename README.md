# ====================================================================
#    PORTAFOLIO DE SISTEMAS OPERATIVOS | EPN - FIEEC (2026)
# ====================================================================

Bienvenido al repositorio oficial de practicas, scripts de administracion y
documentacion tecnica de la asignatura de Sistemas Operativos. Aqui
encontraras la comparativa practica entre entornos Windows (PowerShell) y
GNU/Linux (Bash / AlmaLinux) desarrollada semana a semana.

+--------------------------------------------------------------------+
| FICHA TECNICA DEL PROYECTO                                         |
+--------------------------------------------------------------------+
| [*] Integrantes : Nicolas Galan, Leonardo Vilanez                  |
| [*] Docente     : Ing. Ruben Rumipamba                             |
| [*] Facultad    : Ingenieria Electrica y Electronica (FIEEC - EPN) |
| [*] Entornos SO : Windows 11 Pro (PowerShell) / AlmaLinux 9 (Bash) |
+--------------------------------------------------------------------+

---

## [>>] INDICE DE NAVEGACION POR SEMANAS

Haz clic en cualquiera de los modulos para ir directamente a los scripts,
tablas de comandos y reportes de salida (.txt):

| Carpeta / Enlace | Tema Principal | Scripts Desarrollados | Estado |
| :--- | :--- | :--- | :--- |
| **[`./Semana1`](./Semana1)** | Arquitectura de Computadoras e Inventario de Hardware | `inventario.ps1` / `inventario.sh` | `[COMPLETADO]` |
| **[`./Semana2`](./Semana2)** | Jerarquia de Memoria, Cache, Endianness y Datos | `memoria.ps1` / `memoria.sh` | `[COMPLETADO]` |
| **[`./Semana3`](./Semana3)** | Administracion de Procesos, Módulos y Arranque del SO | `informe_arranque.ps1` / `informe_arranque.sh` | `[EN PROGRESO]` |

---

## [>>] ARQUITECTURA DE CADA MODULO SEMANAL

Cada carpeta semanal sigue un estandar riguroso de entrega:

```text
portafolio-so-galan-vila-ez/
├── README.md                  <-- Portada general del repositorio (este archivo)
├── Semana1/
│   ├── README.md              <-- Documentacion y prompts de la Semana 1
│   ├── Comandos.md            <-- Ayuda memoria comparativa (Win vs Linux)
│   ├── inventario.ps1         <-- Script PowerShell de recoleccion de hardware
│   ├── inventario.sh          <-- Script Bash de recoleccion de hardware
│   └── *.txt                  <-- Capturas reales de ejecucion en consola
└── Semana2/
    ├── README.md              <-- Documentacion y prompts de la Semana 2
    ├── Comandos.md            <-- Ayuda memoria: Memoria, Cache y Hexadecimal
    ├── memoria.ps1            <-- Script PowerShell de jerarquia de memoria
    ├── memoria.sh             <-- Script Bash de cache L1d, RAM y localidad
    └── *.txt                  <-- Capturas de salida de ambos sistemas
