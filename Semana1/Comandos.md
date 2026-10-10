
# Ayuda Memoria: Comandos de Sistemas Operativos - Semana 1
**Materia:** Sistemas Operativos (EPN)  
**Profesor:** Rubén Rumipamba  
**Repositorio:** `Arnick69/portafolio-so-galan-vila-ez`

---

## 1. Comandos de Creación y Gestión de Repositorio (Git & GitHub)

| Comando | Sintaxis / Ejemplo | Descripción y Efecto |
| :--- | :--- | :--- |
| **Identidad local** | `git config --global user.name "TuNombre"`<br>`git config --global user.email "tu@correo.com"` | Configura el nombre y correo que firmarán todos los commits del repositorio. |
| **Inicializar repositorio** | `git init` | Crea un repositorio Git local nuevo inicializando la carpeta oculta `.git`. |
| **Clonar repositorio** | `git clone https://github.com/Arnick69/portafolio-so-galan-vila-ez.git` | Descarga una copia exacta de un repositorio remoto hacia la máquina local. |
| **Vincular remoto** | `git remote add origin https://github.com/Arnick69/portafolio-so-galan-vila-ez.git` | Asocia el repositorio local con el repositorio remoto alojado en GitHub. |
| **Verificar remoto** | `git remote -v` | Muestra las URLs remotas configuradas para lectura (`fetch`) y subida (`push`). |
| **Rama principal** | `git branch -M main` | Renombra la rama actual activa a `main`. |
| **Estado de archivos** | `git status` | Muestra el estado del árbol de trabajo (archivos modificados, nuevos o en staging). |
| **Preparar archivos** | `git add .` o `git add <archivo>` | Agrega los archivos modificados al área de preparación (*staging area*). |
| **Crear commit** | `git commit -m "Mensaje descriptivo"` | Registra una instantánea de los cambios preparados con su mensaje de auditoría. |
| **Descargar cambios** | `git pull --rebase` | Trae los commits de GitHub e inserta los cambios locales sobre ellos sin bifurcar. |
| **Subida inicial** | `git push -u origin main` | Sube los cambios y establece la vinculación de seguimiento con la rama remota. |
| **Subida estándar** | `git push` | Envía todos los commits locales confirmados hacia el repositorio en GitHub. |
| **Eliminar archivo de Git** | `git rm <archivo>` | Borra el archivo del disco y prepara su eliminación en el siguiente commit. |
| **Desvincular sin borrar** | `git rm --cached <archivo>` | Quita el archivo del control de versiones manteniendo una copia en el disco local. |

---

## 2. Comandos de Hardware y Arquitectura (Diapositivas Semana 1)

Inspección de los bloques funcionales fundamentales (CPU, Memoria, Almacenamiento, Buses y E/S) tanto en Linux como en Windows.

| Bloque Funcional | Comando Linux (Bash) | Comando Windows (PowerShell) | ¿Qué hace y qué datos extrae? |
| :--- | :--- | :--- | :--- |
| **CPU (Modelo y Núcleos)** | `lscpu`<br>`cat /proc/cpuinfo` | `Get-CimInstance Win32_Processor` | Muestra modelo del procesador, arquitectura, zócalos, núcleos físicos e hilos lógicos. |
| **CPU (Frecuencia y Caché)** | `lscpu \| grep -E 'Model name
