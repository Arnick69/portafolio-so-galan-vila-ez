# Define el nombre del archivo donde se guardará la información
$archivoLog = "estado_windows.log"

# Encabezado principal
echo "=================================================" > $archivoLog
echo "    ANALISIS PROFUNDO DEL SISTEMA - WINDOWS      " >> $archivoLog
echo "=================================================" >> $archivoLog
echo "Fecha y hora de ejecucion: $(Get-Date)" >> $archivoLog
echo "Nombre del Equipo: $env:COMPUTERNAME" >> $archivoLog
echo "Usuario Actual: $env:USERNAME" >> $archivoLog

echo "`n---------- 1. PROCESADOR (CPU) ----------" >> $archivoLog
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors >> $archivoLog

echo "`n---------- 2. MEMORIA RAM ----------" >> $archivoLog
Get-CimInstance Win32_PhysicalMemory | Select-Object Capacity, Manufacturer >> $archivoLog

echo "`n---------- 3. ALMACENAMIENTO ----------" >> $archivoLog
Get-Volume >> $archivoLog

echo "`n---------- 4. CONEXIONES DE RED ACTIVAS ----------" >> $archivoLog
Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object Name, InterfaceDescription, MacAddress >> $archivoLog
ipconfig | Select-String "IPv4" >> $archivoLog

echo "`n---------- 5. TOP 10 PROCESOS QUE MAS CONSUMEN CPU ----------" >> $archivoLog
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, Id, CPU >> $archivoLog

echo "`n---------- 6. ESTADO DE SERVICIOS (Muestra 15 activos) ----------" >> $archivoLog
Get-Service | Where-Object Status -eq 'Running' | Select-Object -First 15 Name, DisplayName >> $archivoLog

echo "`n---------- 7. RESUMEN DEL SISTEMA OPERATIVO ----------" >> $archivoLog
systeminfo | Select-String "OS Name","OS Version","System Manufacturer","System Model" >> $archivoLog

Write-Host "Analisis profundo completado. El archivo $archivoLog ha sido actualizado."

# Sincronización automática con GitHub
Write-Host "Iniciando subida automatica a GitHub..."
git add estado_windows.log
git add analisis_windows.ps1
git commit -m "Actualiza registro automatico del sistema Windows"
git push
Write-Host "¡Archivos subidos exitosamente a tu repositorio!"