<#
.SYNOPSIS
    Auditoria de seguridad del equipo en Windows (Deber 5 - Semana 5).
.DESCRIPTION
    Evalua 5 controles de seguridad sin requerir permisos de Administrador:
    (1) Llavero maestro (Grupo S-1-5-32-544 y cuenta integrada -500),
    (2) Puertas abiertas (puertos TCP expuestos 21, 23, 3306, 3389, 5900),
    (3) Portero activo (perfiles de Windows Defender Firewall),
    (4) Intentos fallidos (Eventos 4625 desde muestra CSV o registro),
    (5) Veredicto final (exit 0 = OK, exit 1 = ALERTA).
.NOTES
    Asignatura : Sistemas Operativos (EPN - FIEEC)
    Autores    : Nicolas Galan, Leonardo Vilanez
    Fecha      : 2026-11-16
    Uso de IA  : Asistencia en el filtrado de objetos PowerShell y manejo de
                 parametros de entrada. Validado y probado por el equipo.
#>

param(
    [string]$Muestra = "",
    [int]$Umbral = 5
)

$HostEquipo = $env:COMPUTERNAME
$FechaActual = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ArchivoSalida = "auditoria_$HostEquipo.txt"

$EstadoS1 = "OK"
$EstadoS2 = "OK"
$EstadoS3 = "OK"
$EstadoS4 = "OK"

$Reporte = New-Object System.Collections.Generic.List[string]

function Add-Linea {
    param([string]$Texto = "")
    $Reporte.Add($Texto)
    Write-Output $Texto
}

# ------------------------------------------------------------------------------
# Seccion 1: Llavero maestro
# Regla de ALERTA: La cuenta integrada Administrador (SID ...-500) esta habilitada.
# ------------------------------------------------------------------------------
function Invoke-Seccion1Llavero {
    Add-Linea "------------------------------------------------------------------"
    Add-Linea "[SECCION 1] LLAVERO MAESTRO (GRUPO ADMINISTRADORES S-1-5-32-544)"
    Add-Linea "------------------------------------------------------------------"

    try {
        $miembros = Get-LocalGroupMember -SID 'S-1-5-32-544' -ErrorAction Stop
        foreach ($m in $miembros) {
            Add-Linea ("  - {0} ({1}) | SID: {2}" -f $m.Name, $m.ObjectClass, $m.SID)
        }
    } catch {
        Add-Linea "  Aviso: No se pudo enumerar con Get-LocalGroupMember; usando net localgroup."
        $netOut = net localgroup Administradores 2>$null
        foreach ($l in $netOut) { Add-Linea "  $l" }
    }

    $adminIntegrado = Get-LocalUser -ErrorAction SilentlyContinue | Where-Object { $_.SID.Value -like '*-500' }
    if ($adminIntegrado) {
        Add-Linea ("Cuenta integrada (-500): {0} | Habilitada: {1}" -f $adminIntegrado.Name, $adminIntegrado.Enabled)
        if ($adminIntegrado.Enabled -eq $true) {
            $script:EstadoS1 = "ALERTA"
            Add-Linea "Detalle: La cuenta integrada Administrador (-500) se encuentra habilitada."
        }
    }

    Add-Linea "-> Seccion 1: $script:EstadoS1"
    Add-Linea ""
}

# ------------------------------------------------------------------------------
# Seccion 2: Puertas abiertas
# Regla de ALERTA: Puertos 21, 23, 3306, 3389 o 5900 escuchando hacia la red.
# ------------------------------------------------------------------------------
function Invoke-Seccion2Puertas {
    Add-Linea "------------------------------------------------------------------"
    Add-Linea "[SECCION 2] PUERTAS ABIERTAS (PUERTOS TCP EN ESCUCHA)"
    Add-Linea "------------------------------------------------------------------"

    $puertosProhibidos = @(21, 23, 3306, 3389, 5900)
    $conexiones = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Sort-Object LocalPort

    foreach ($c in ($conexiones | Select-Object -First 15)) {
        Add-Linea ("  {0,-22} Puerto: {1,-6} PID: {2}" -f $c.LocalAddress, $c.LocalPort, $c.OwningProcess)
    }
    if ($conexiones.Count -gt 15) {
        Add-Linea ("  ... ({0} puertos adicionales en escucha)" -f ($conexiones.Count - 15))
    }

    $expuestos = $conexiones | Where-Object {
        ($_.LocalPort -in $puertosProhibidos) -and ($_.LocalAddress -notin @('127.0.0.1', '::1'))
    }

    if ($expuestos) {
        $script:EstadoS2 = "ALERTA"
        Add-Linea "Detalle: Puerto(s) inseguro(s) expuesto(s) hacia la red:"
        foreach ($e in $expuestos) {
            Add-Linea ("  - {0}:{1} (PID {2})" -f $e.LocalAddress, $e.LocalPort, $e.OwningProcess)
        }
    }

    Add-Linea "-> Seccion 2: $script:EstadoS2"
    Add-Linea ""
}

# ------------------------------------------------------------------------------
# Seccion 3: Portero activo
# Regla de ALERTA: Algun perfil de Windows Defender Firewall esta deshabilitado.
# ------------------------------------------------------------------------------
function Invoke-Seccion3Portero {
    Add-Linea "------------------------------------------------------------------"
    Add-Linea "[SECCION 3] PORTERO ACTIVO (PERFILES DEFENDER FIREWALL)"
    Add-Linea "------------------------------------------------------------------"

    $perfiles = Get-NetFirewallProfile -ErrorAction SilentlyContinue
    foreach ($p in $perfiles) {
        Add-Linea ("  Perfil: {0,-10} | Habilitado: {1,-6} | Entrada: {2}" -f $p.Name, $p.Enabled, $p.DefaultInboundAction)
        if ($p.Enabled -ne $true) {
            $script:EstadoS3 = "ALERTA"
        }
    }

    if ($script:EstadoS3 -eq "ALERTA") {
        Add-Linea "Detalle: Uno o mas perfiles del cortafuegos estan deshabilitados."
    }

    Add-Linea "-> Seccion 3: $script:EstadoS3"
    Add-Linea ""
}

# ------------------------------------------------------------------------------
# Seccion 4: Intentos fallidos (IDS - Eventos 4625)
# Regla de ALERTA: Alguna IP alcanza o supera el umbral (-Umbral) en eventos 4625.
# ------------------------------------------------------------------------------
function Invoke-Seccion4Bitacora {
    Add-Linea "------------------------------------------------------------------"
    Add-Linea "[SECCION 4] INTENTOS FALLIDOS - EVENTOS 4625 (UMBRAL: $Umbral)"
    Add-Linea "------------------------------------------------------------------"

    $eventos = @()

    if ($Muestra -ne "") {
        if (-not (Test-Path $Muestra)) {
            Add-Linea "Error: No se encuentra el archivo de muestra '$Muestra'."
            $script:EstadoS4 = "ALERTA"
            Add-Linea "-> Seccion 4: $script:EstadoS4"
            Add-Linea ""
            return
        }
        Add-Linea "Fuente analizada: Archivo de muestra ($Muestra)"
        $eventos = Import-Csv -Path $Muestra | Where-Object { $_.Id -eq '4625' }
    } else {
        Add-Linea "Fuente analizada: Registro de Seguridad de Windows (ultimas 24h)"
        try {
            $hace24h = (Get-Date).AddHours(-24)
            $raw = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=$hace24h} -ErrorAction Stop
            $eventos = $raw | ForEach-Object {
                [PSCustomObject]@{ Id = '4625'; IpAddress = $_.Properties[19].Value }
            }
        } catch {
            Add-Linea "  Aviso: Sin permisos de Administrador para leer Security en vivo (use -Muestra)."
        }
    }

    if ($eventos.Count -eq 0) {
        Add-Linea "No se registraron eventos 4625 para analizar."
    } else {
        $agrupados = $eventos | Where-Object { $_.IpAddress -and $_.IpAddress -ne '-' } |
                     Group-Object IpAddress | Sort-Object Count -Descending

        Add-Linea "Conteo de eventos 4625 por IP:"
        foreach ($g in $agrupados) {
            Add-Linea ("  {0,4} fallos -> {1}" -f $g.Count, $g.Name)
        }

        $alertasIp = $agrupados | Where-Object { $_.Count -ge $Umbral }
        if ($alertasIp) {
            $script:EstadoS4 = "ALERTA"
            Add-Linea "Detalle: IP(s) que alcanzan o superan el umbral ($Umbral):"
            foreach ($a in $alertasIp) {
                Add-Linea ("  - {0} ({1} fallos)" -f $a.Name, $a.Count)
            }
        }
    }

    Add-Linea "-> Seccion 4: $script:EstadoS4"
    Add-Linea ""
}

# ------------------------------------------------------------------------------
# Seccion 5: Veredicto final
# Regla de salida: exit 0 si todo esta OK; exit 1 si existe alguna ALERTA.
# ------------------------------------------------------------------------------
function Invoke-Seccion5Veredicto {
    Add-Linea "=================================================================="
    Add-Linea "[SECCION 5] VEREDICTO CONSOLIDADO DE AUDITORIA"
    Add-Linea "=================================================================="
    Add-Linea "  1. Llavero maestro   : $script:EstadoS1"
    Add-Linea "  2. Puertas abiertas  : $script:EstadoS2"
    Add-Linea "  3. Portero activo    : $script:EstadoS3"
    Add-Linea "  4. Intentos fallidos : $script:EstadoS4"
    Add-Linea "------------------------------------------------------------------"

    if ($script:EstadoS1 -eq "OK" -and $script:EstadoS2 -eq "OK" -and $script:EstadoS3 -eq "OK" -and $script:EstadoS4 -eq "OK") {
        Add-Linea "VEREDICTO FINAL: OK (Equipo conforme a la politica base)"
        Add-Linea "=================================================================="
        $Reporte | Out-File -FilePath $ArchivoSalida -Encoding UTF8
        exit 0
    } else {
        Add-Linea "VEREDICTO FINAL: ALERTA (Se requiere revision de seguridad)"
        Add-Linea "=================================================================="
        $Reporte | Out-File -FilePath $ArchivoSalida -Encoding UTF8
        exit 1
    }
}

Add-Linea "=================================================================="
Add-Linea " REPORTE DE AUDITORIA DE SEGURIDAD - WINDOWS (POWERSHELL)"
Add-Linea " Equipo: $HostEquipo | Fecha: $FechaActual"
Add-Linea "=================================================================="
Add-Linea ""

Invoke-Seccion1Llavero
Invoke-Seccion2Puertas
Invoke-Seccion3Portero
Invoke-Seccion4Bitacora
Invoke-Seccion5Veredicto
