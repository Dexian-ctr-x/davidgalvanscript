# Script: DavidGalvansp31-3.ps1
# Menu con los registros de eventos que tiene ESTA maquina.


# Bucle: se repite hasta que el usuario pulse 0
do {
    # El menu se construye con los registros que existan en la maquina
    $registros = @(Get-EventLog -List | Sort-Object Log)

    Write-Output ""
    Write-Output "===== REGISTROS DE EVENTOS ====="

    # Mostramos cada registro con un numero (1, 2, 3...)
    for ($i = 0; $i -lt $registros.Count; $i++) {
        $numero = $i + 1
        Write-Output "$numero. $($registros[$i].Log)"
    }
    Write-Output "0. Salir"

    $opcion = Read-Host "Elige una opcion"

    if ($opcion -eq "0") {
        Write-Output "Saliendo..."
    }
    elseif ($opcion -match '^\d+$' -and [int]$opcion -ge 1 -and [int]$opcion -le $registros.Count) {
        # Registro elegido (la posicion en la lista es el numero menos 1)
        $nombre = $registros[[int]$opcion - 1].Log

        try {
            # Total de eventos del registro
            $total = (Get-EventLog -LogName $nombre -ErrorAction Stop | Measure-Object).Count
            Write-Output ""
            Write-Output "Registro '$nombre': $total eventos en total."
            Write-Output "Ultimos 12 registros:"

            # Los 12 mas recientes
            Get-EventLog -LogName $nombre -Newest 12 |
                Format-Table TimeGenerated, EntryType, Source, EventID -AutoSize
        }
        catch {
            Write-Host "No se pudo leer '$nombre': $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        # Cualquier otra cosa no esta en el menu
        Write-Host "Opcion no valida." -ForegroundColor Red
    }
} while ($opcion -ne "0")
