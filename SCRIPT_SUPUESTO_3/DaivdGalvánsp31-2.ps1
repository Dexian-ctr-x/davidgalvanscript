
# 1) Parámetros del script
param(
    [Parameter(Mandatory = $true)][string]$FechaInicio,   # fecha de inicio
    [Parameter(Mandatory = $true)][string]$FechaFin       # fecha de fin
)

# 2) Conversión explícita de texto a fecha (evita confundir día y mes)
$formatos = 'dd/MM/yyyy', 'd/M/yyyy', 'yyyy-MM-dd'
$cultura  = [System.Globalization.CultureInfo]::InvariantCulture
try {
    $inicio = [datetime]::ParseExact($FechaInicio, $formatos, $cultura, 'None')
    $fin    = [datetime]::ParseExact($FechaFin,    $formatos, $cultura, 'None')
} catch {
    Write-Host "Fecha no válida. Usa el formato dd/MM/yyyy (ejemplo: 01/10/2026)." -ForegroundColor Red
    exit 1
}
if ($fin -lt $inicio) {
    Write-Host "La fecha de fin no puede ser anterior a la de inicio." -ForegroundColor Red
    exit 1
}
# Se incluye el día final completo (hasta las 23:59:59)
$fin = $fin.Date.AddDays(1).AddSeconds(-1)

# 3) Consulta del registro Seguridad: solo ID 4624 y solo dentro del rango
$eventos = Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4624
    StartTime = $inicio.Date
    EndTime   = $fin
} -ErrorAction SilentlyContinue

# 4) Se recorre cada evento, se extrae el usuario y se descarta SYSTEM
$resultado = foreach ($e in $eventos) {
    $xml = [xml]$e.ToXml()
    # TargetUserName = usuario que inicia sesión
    $usuario = ($xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'

    if ($usuario -ne 'SYSTEM') {            # exclusión del usuario SYSTEM
        [pscustomobject]@{
            Dia     = $e.TimeCreated.ToString('dd/MM/yyyy')
            Hora    = $e.TimeCreated.ToString('HH:mm:ss')
            Usuario = $usuario
        }
    }
}

# 5) Salida: listado ordenado por fecha/hora y total
if ($resultado) {
    $resultado | Sort-Object { [datetime]("$($_.Dia) $($_.Hora)") } | Format-Table Dia, Hora, Usuario -AutoSize
    Write-Host "Total de inicios de sesión: $(@($resultado).Count)" -ForegroundColor Green
} else {
    Write-Host "No hay inicios de sesión entre $FechaInicio y $FechaFin." -ForegroundColor Yellow
}
