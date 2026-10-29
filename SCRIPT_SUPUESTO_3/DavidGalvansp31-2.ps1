# Script: nombresp31-2.ps1
# Muestra los inicios de sesion entre dos fechas (sin contar al usuario SYSTEM)
# Los inicios de sesion estan en el registro Security y tienen el ID 4624
# Uso: .\nombresp31-2.ps1 -FechaInicio 01/10/2026 -FechaFin 29/10/2026
# Ejecutar PowerShell como Administrador

# Parametros: fecha de inicio y fecha de fin
param(
    [string]$FechaInicio,
    [string]$FechaFin
)

# Convertimos el texto a fecha (usa el formato de fecha del servidor: dd/MM/yyyy)
$inicio = Get-Date $FechaInicio
$fin = (Get-Date $FechaFin).AddDays(1)    # se suma un dia para incluir el ultimo dia completo

Write-Output "Inicios de sesion entre $FechaInicio y $FechaFin"

# Buscamos en el registro Security los eventos 4624 entre las dos fechas
$eventos = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624; StartTime=$inicio; EndTime=$fin}

# Recorremos los eventos y sacamos dia, hora y usuario
$lista = foreach ($evento in $eventos) {
    # El usuario que inicia sesion esta en la propiedad 5 del evento
    $usuario = $evento.Properties[5].Value

    # Descartamos el usuario SYSTEM
    if ($usuario -ne "SYSTEM") {
        [PSCustomObject]@{
            Dia     = $evento.TimeCreated.ToString("dd/MM/yyyy")
            Hora    = $evento.TimeCreated.ToString("HH:mm:ss")
            Usuario = $usuario
        }
    }
}

# Mostramos el listado y el total
$lista | Format-Table -AutoSize
Write-Output "Total: $(@($lista).Count) inicios de sesion"
