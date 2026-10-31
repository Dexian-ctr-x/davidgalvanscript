#!/bin/bash
# Comprueba el porcentaje de uso de cada particion con df.
# Si alguna supera el umbral (80 % por defecto), escribe una linea en un log propio
# con fecha, hora, particion y porcentaje.

# Umbral: si no se indica otro, 80
UMBRAL="${UMBRAL:-80}"

# Fichero de registro propio
LOG="${LOG:-$HOME/DavidGalvansp31-7.log}"

# df -P da una salida estable; se excluyen los sistemas de ficheros virtuales
# tail -n +2 salta la cabecera de df
df -P -x tmpfs -x devtmpfs -x squashfs -x overlay | tail -n +2 | while read -r particion tam usado libre porcentaje montaje; do

    # Quitamos el simbolo % para poder comparar como numero (85% -> 85)
    uso="${porcentaje%\%}"

    # Si el uso supera el umbral, se anota en el log
    if [ "$uso" -gt "$UMBRAL" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') | Particion: $particion ($montaje) | Uso: ${uso}%" >> "$LOG"
    fi
done
