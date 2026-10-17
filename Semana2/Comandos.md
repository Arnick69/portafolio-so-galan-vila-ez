
# [=== AYUDA MEMORIA: COMANDOS SEMANA 2 ===]

* Materia: Sistemas Operativos (EPN)
* Docente: Ruben Rumipamba
* Integrantes: Nicolas Galan, Leonardo Vilanez
* Tema: Jerarquia de memoria, cache y representacion de datos

---

## [1] Tabla comparativa: Memoria y Cache (Windows vs Linux)

| Que hace el comando | Windows (PowerShell) | Linux (Bash) |
| :--- | :--- | :--- |
| Ver arquitectura del CPU | `$env:PROCESSOR_ARCHITECTURE` | `uname -m` |
| Ver orden de bytes (Endianness) | `[BitConverter]::IsLittleEndian` | `lscpu \| grep 'Byte Order'` |
| Ver niveles de cache (L1, L2, L3) | `Get-CimInstance Win32_CacheMemory \| Select-Object Purpose, InstalledSize` | `lscpu --caches` |
| Ver tamano de linea de cache L1d | `(Get-CimInstance Win32_CacheMemory)[0].LineSize` | `getconf LEVEL1_DCACHE_LINESIZE` |
| Ver memoria RAM y Swap / Paginacion | `Get-CimInstance Win32_OperatingSystem \| Select-Object TotalVisibleMemorySize, FreePhysicalMemory` | `free -h` |
| Ver discos fisicos y tipo (SSD/HDD) | `Get-PhysicalDisk \| Select-Object FriendlyName, MediaType, Size` | `lsblk -d -o NAME,ROTA,SIZE` |

---

## [2] Tabla comparativa: Representacion de datos y Hexadecimal

| Que hace el comando | Windows (PowerShell) | Linux (Bash) |
| :--- | :--- | :--- |
| Crear archivo de texto en UTF-8 | `'Año' \| Set-Content t.txt -Encoding utf8NoBOM` | `printf 'Año\n' > t.txt` |
| Volcado hexadecimal de un archivo | `Format-Hex t.txt` | `xxd t.txt` o `hexdump -C t.txt` |
| Generar binario de 32 bits con signo | `[IO.File]::WriteAllBytes('n.bin', [BitConverter]::GetBytes(-100))` | `python3 -c "import struct; open('n.bin','wb').write(struct.pack('<i', -100))"` |
| Medir tiempo de ejecucion (Localidad) | `Measure-Command { .\matriz.exe }` | `./matriz` (por filas) y `./matriz c` (por columnas) |

---

## [3] Notas rapidas de la semana

* [+] Salto de linea: En Windows se usa `0D 0A` (CR LF), mientras que en Linux solo `0A` (LF).
* [+] Little-endian: El byte menos significativo se guarda en la direccion mas baja de memoria (ej. 300 = `0x0000012C` se almacena como `2C 01 00 00`).
* [+] Disco rotacional en Linux (`ROTA`): `1` significa disco mecanico (HDD), `0` significa estado solido (SSD/NVMe).
* [+] Formula de conjuntos de cache: `S = C / (L * A)`
  --> `C` = Capacidad en bytes
  --> `L` = Tamano de linea en bytes
  --> `A` = Vias de asociatividad (ways)
