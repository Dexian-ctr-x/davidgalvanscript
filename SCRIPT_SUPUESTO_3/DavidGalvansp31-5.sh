#!/bin/bash
# Revisa los archivos de /var/log y busca las lineas con "error" o "fail".
# Crea un informe indicando de que archivo viene cada bloque de lineas.

# Fichero del informe (en el directorio del usuario, con fecha y hora)
INFORME="$HOME/informe_errores_$(date +%Y-%m-%d_%H%M).txt"

# Sin sudo algunos logs no se pueden leer
if [ "$EUID" -ne 0 ]; then
    echo "Aviso: sin sudo no se podran leer todos los logs."
fi

# Cabecera del informe
echo "################################################################" > "$INFORME"
echo "  INFORME DE ERRORES - $(hostname)" >> "$INFORME"
echo "  Fecha: $(date '+%d/%m/%Y %H:%M:%S')" >> "$INFORME"
echo "################################################################" >> "$INFORME"

TOTAL_ARCHIVOS=0

# Recorremos todos los archivos de /var/log (find los busca, sort los ordena)
for archivo in $(find /var/log -type f 2>/dev/null | sort); do

    # Buscamos "error" o "fail" sin distinguir mayusculas (-i)
    # -I ignora los archivos binarios (como wtmp o lastlog)
    # Los .gz (logs rotados) se leen con zgrep
    if [[ "$archivo" == *.gz ]]; then
        lineas=$(zgrep -iE "error|fail" "$archivo" 2>/dev/null)
    else
        lineas=$(grep -IiE "error|fail" "$archivo" 2>/dev/null)
    fi

    # Si el archivo tiene lineas con errores, las escribimos en el informe
    if [ -n "$lineas" ]; then
        cantidad=$(echo "$lineas" | wc -l)
        TOTAL_ARCHIVOS=$((TOTAL_ARCHIVOS + 1))

        echo "" >> "$INFORME"
        echo "================================================================" >> "$INFORME"
        echo " ARCHIVO: $archivo  ($cantidad lineas)" >> "$INFORME"
        echo "================================================================" >> "$INFORME"
        echo "$lineas" >> "$INFORME"
    fi
done

# Resumen final
echo "" >> "$INFORME"
echo "################################################################" >> "$INFORME"
echo "  Archivos con errores: $TOTAL_ARCHIVOS" >> "$INFORME"
echo "################################################################" >> "$INFORME"

echo "Informe generado en: $INFORME"
