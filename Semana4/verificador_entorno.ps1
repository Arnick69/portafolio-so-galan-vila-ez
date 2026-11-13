<#
.SYNOPSIS
    Verificador de entorno para la materia de Sistemas Operativos (Semana 4 - Deber 4).
.DESCRIPTION
    Revisa el sistema operativo, versión de PowerShell, herramientas requeridas,
    orígenes de paquetes (winget y registro), últimas 5 instalaciones y devuelve
    código de salida 0 si todo está listo o 1 si falta alguna herramienta.
    No requiere permisos de Administrador.
.NOTES
    Autores        : Nicolas Galán y Leonardo Vilanez
    Asignatura     : Sistemas Operativos (EPN - FIEEC)
    Fecha          : Noviembre 2026
    Declaración IA : Asistencia en formato de tablas y consulta al Registro Uninstall.
#>

$Equipo = $env:COMPUTERNAME
if ([string]::IsNullOrWhiteSpace($Equipo)) { $Equipo = "DESKTOP-FIEECEC" }
$ArchivoSalida = "verificador_entorno_${Equipo}.txt"

Start-Transcript -Path $ArchivoSalida -Force | Out-Null

Write-Output "======================================================================"
Write-Output "        VERIFICADOR DE ENTORNO DE SISTEMAS OPERATIVOS (WINDOWS)       "
Write-Output "======================================================================"
Write-Output ("Fecha de ejecución : {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Write-Output ("Equipo             : {0}" -f $Equipo)
Write-Output ("Usuario            : {0}" -f $env:USERNAME)
Write-Output ""

# ------------------------------------------------------------------------------
# SECCIÓN 1: Sistema y Shell
# ------------------------------------------------------------------------------
Write-Output "--- [1] SISTEMA Y SHELL ---"
$OS = Get-CimInstance Win32_OperatingSystem
Write-Output ("Sistema Operativo  : {0} ({1})" -f $OS.Caption, $OS.OSArchitecture)
Write-Output ("Versión del Núcleo : {0} (Build {1})" -f $OS.Version, $OS.BuildNumber)
Write-Output ("Edición PowerShell : {0} v{1}" -f $PSVersionTable.PSEdition, $PSVersionTable.PSVersion.ToString())
Write-Output ""

# ------------------------------------------------------------------------------
# SECCIÓN 2: Herramientas requeridas
# ------------------------------------------------------------------------------
Write-Output "--- [2] HERRAMIENTAS REQUERIDAS ---"
$MapaHerramientas = [ordered]@{
    "git"      = "Git.Git"
    "curl.exe" = "cURL.cURL"
    "python"   = "Python.Python.3.12"
    "jq"       = "jqlang.jq"
    "winget"   = "Microsoft.AppInstaller"
}

$Total = $MapaHerramientas.Count
$Listas = 0
$Faltantes = @()
$IdsFaltantes = @()

Write-Output ("{0,-12} | {1,-8} | {2,-32} | {3}" -f "Herramienta", "Estado", "Ruta", "Versión")
Write-Output "----------------------------------------------------------------------"

foreach ($cmd in $MapaHerramientas.Keys) {
    $infoCmd = Get-Command $cmd -ErrorAction SilentlyContinue
    if ($null -ne $infoCmd) {
        $verTexto = (& $cmd --version 2>&1 | Select-Object -First 1) -as [string]
        if ([string]::IsNullOrWhiteSpace($verTexto)) { $verTexto = $infoCmd.Version.ToString() }
        if ($verTexto.Length -gt 28) { $verTexto = $verTexto.Substring(0, 28) }
        $rutaCorta = $infoCmd.Source
        if ($rutaCorta.Length -gt 32) { $rutaCorta = "..." + $rutaCorta.Substring($rutaCorta.Length - 29) }
        Write-Output ("{0,-12} | {1,-8} | {2,-32} | {3}" -f $cmd, "OK", $rutaCorta, $verTexto)
        $Listas++
    } else {
        Write-Output ("{0,-12} | {1,-8} | {2,-32} | {3}" -f $cmd, "FALTA", "-", "No instalado")
        $Faltantes += $cmd
        $IdsFaltantes += $MapaHerramientas[$cmd]
    }
}
Write-Output ""

# ------------------------------------------------------------------------------
# SECCIÓN 3: Paquetes y orígenes
# ------------------------------------------------------------------------------
Write-Output "--- [3] PAQUETES Y ORÍGENES ---"
$RutasRegistro = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$AppsInstaladas = Get-ItemProperty $RutasRegistro -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName }
Write-Output ("Programas registrados en Windows (Uninstall) : {0}" -f $AppsInstaladas.Count)
Write-Output ""
Write-Output "Orígenes configurados en winget (winget source list):"
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget source list | ForEach-Object { Write-Output ("  " + $_) }
} else {
    Write-Output "  Aviso: winget no está disponible en este equipo."
}
Write-Output ""

# ------------------------------------------------------------------------------
# SECCIÓN 4: Últimas 5 instalaciones
# ------------------------------------------------------------------------------
Write-Output "--- [4] ÚLTIMAS 5 INSTALACIONES ---"
$Ultimas5 = $AppsInstaladas |
    Where-Object { $_.InstallDate -match '^\d{8}$' } |
    Sort-Object InstallDate -Descending |
    Select-Object -First 5 DisplayName, DisplayVersion, Publisher, InstallDate

foreach ($app in $Ultimas5) {
    Write-Output ("  - {0} | Nombre: {1} (v{2}) | Publicador: {3}" -f $app.InstallDate, $app.DisplayName, $app.DisplayVersion, $app.Publisher)
}
Write-Output ""

# ------------------------------------------------------------------------------
# SECCIÓN 5: Qué falta y cómo instalarlo (Incluye Reto Final Taller 2)
# ------------------------------------------------------------------------------
Write-Output "--- [5] QUÉ FALTA Y CÓMO INSTALARLO ---"
if ($Faltantes.Count -eq 0) {
    Write-Output "Todas las herramientas requeridas están instaladas correctamente."
} else {
    Write-Output ("Faltan {0} herramienta(s): {1}" -f $Faltantes.Count, ($Faltantes -join ", "))
    $ComandosInstalar = ($IdsFaltantes | ForEach-Object { "winget install --id $_ -e" }) -join "; "
    Write-Output "Comando exacto para instalar todo lo que falta de una sola vez:"
    Write-Output ("  " + $ComandosInstalar)
}
Write-Output ""

# ------------------------------------------------------------------------------
# SECCIÓN 6: Resultado final
# ------------------------------------------------------------------------------
Write-Output "--- [6] RESULTADO ---"
Write-Output ("Herramientas listas: {0} de {1}" -f $Listas, $Total)
Write-Output ("Informe guardado en: {0}" -f $ArchivoSalida)

Stop-Transcript | Out-Null

if ($Listas -eq $Total) {
    Write-Output "Estado final       : COMPLETO (Código de salida: 0)"
    exit 0
} else {
    Write-Output "Estado final       : INCOMPLETO (Código de salida: 1)"
    exit 1
}
