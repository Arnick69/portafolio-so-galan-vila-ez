# ==============================================================================
# Script      : informe_arranque.ps1
# Asignatura  : Sistemas Operativos - Semana 3 (Deber 3)
# Docente     : Ing. Rubén Rumipamba
# Autores     : Nicolás Galán, Leonardo Vilañez
# Paralelo    : GR1
# Fecha       : 2026-10-19
# Declaración : Uso de IA generativa (Gemini) como apoyo para depurar la consulta
#               XML del Evento 100 y validar permisos con EsAdministrador.
# ==============================================================================

$Equipo = $env:COMPUTERNAME
$Fecha = Get-Date -Format "yyyy-MM-dd"
$Salida = "informe_arranque_${Equipo}_${Fecha}.txt"

function EsAdministrador {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$Contenido = & {
    "=================================================================="
    "          INFORME DE ARRANQUE DEL SISTEMA (WINDOWS)               "
    "=================================================================="
    "Equipo  : $Equipo"
    "Fecha   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    "Autores : Nicolás Galán, Leonardo Vilañez (GR1)"
    "=================================================================="
    ""

    # 1 · Sistema operativo, versión y núcleo
    "=== 1 · Sistema operativo, versión y núcleo ==="
    $os = Get-CimInstance Win32_OperatingSystem
    "Sistema     : $($os.Caption)"
    "Versión     : $($os.Version) (Build $($os.BuildNumber))"
    "Arquitectura: $($os.OSArchitecture)"
    ""

    # 2 · Último arranque y tiempo encendido
    "=== 2 · Último arranque y tiempo encendido ==="
    $boot = $os.LastBootUpTime
    $uptime = (Get-Date) - $boot
    "Arrancó  : $($boot.ToString('yyyy-MM-dd HH:mm:ss'))"
    "Encendida: $($uptime.Days) días, $($uptime.Hours) horas, $($uptime.Minutes) minutos"
    ""

    # 3 · Desglose del arranque (FwPOSTTime y Evento 100)
    "=== 3 · Desglose del arranque ==="
    $regPower = Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -ErrorAction SilentlyContinue
    if ($null -ne $regPower -and $null -ne $regPower.FwPOSTTime) {
        $fwS = [math]::Round($regPower.FwPOSTTime / 1000, 3)
        "Firmware (FwPOSTTime): $($regPower.FwPOSTTime) ms ($fwS s)"
    } else {
        "[AVISO] Tiempo de Firmware (FwPOSTTime) no disponible en este equipo."
    }

    if (EsAdministrador) {
        try {
            $e = Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Diagnostics-Performance/Operational'; Id = 100 } -MaxEvents 1 -ErrorAction Stop
            $datos = ([xml]$e.ToXml()).Event.EventData.Data | Where-Object Name -in 'BootTime','MainPathBootTime','BootPostBootTime'
            "Evento 100 (Fecha: $($e.TimeCreated)):"
            foreach ($d in $datos) {
                $s = [math]::Round([double]$d.'#text' / 1000, 3)
                "  - $($d.Name): $($d.'#text') ms ($s s)"
            }
        } catch {
            "[AVISO] No se encontraron eventos ID 100 recientes (posible Inicio Rápido activo)."
        }
    } else {
        "[AVISO] PowerShell sin permisos de Administrador: se omite la lectura del Evento 100 para evitar fallo de acceso."
    }
    ""

    # 4 · Servicios en ejecución y automáticos detenidos
    "=== 4 · Servicios del sistema (Win32_Service) ==="
    $srv = Get-CimInstance Win32_Service
    $running = ($srv | Where-Object State -eq 'Running').Count
    $autoStopped = $srv | Where-Object { $_.StartMode -eq 'Auto' -and $_.State -ne 'Running' }
    "Servicios en ejecución         : $running"
    "Servicios automáticos detenidos: $($autoStopped.Count)"
    "Primeros 5 servicios automáticos detenidos:"
    $autoStopped | Select-Object -First 5 | ForEach-Object {
        "  - $($_.Name) ($($_.DisplayName)) [Estado: $($_.State)]"
    }
    ""

    # 5 · Módulos / controladores
    "=== 5 · Controladores del sistema (driverquery y Win32_SystemDriver) ==="
    $drv = Get-CimInstance Win32_SystemDriver
    $drvRun = $drv | Where-Object State -eq 'Running'
    "Total de controladores registrados : $($drv.Count)"
    "Controladores en ejecución (Running): $($drvRun.Count)"
    "Primeros 5 controladores en ejecución:"
    $drvRun | Select-Object -First 5 | ForEach-Object {
        "  - $($_.Name) | Tipo: $($_.ServiceType) | Estado: $($_.State)"
    }
    ""

    # 6 · Cierre (HiberbootEnabled)
    "=== 6 · Cierre: Estado del Inicio Rápido ==="
    if ($null -ne $regPower -and $null -ne $regPower.HiberbootEnabled) {
        $estado = if ($regPower.HiberbootEnabled -eq 1) { "1 (Activado - Apagar hiberna el núcleo)" } else { "0 (Desactivado - Apagado completo)" }
        "HiberbootEnabled: $estado"
    } else {
        "[AVISO] No se pudo consultar HiberbootEnabled."
    }
    ""
    "=== Fin del informe ==="
}

$Contenido | Out-File -FilePath $Salida -Encoding utf8
$Contenido | Write-Host
Write-Host "`nInforme generado en: $Salida"
