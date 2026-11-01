#!/bin/bash
# Script: difsem.sh  (cron, semanal)
# Copia DIFERENCIAL de /home: solo lo cambiado desde la ultima copia total.
# Nombre: CopDifSem-<numero de semana del año>
DEST=/bacDavidG
MARCA="$DEST/.marca_total.snar"

# Sin copia total previa no hay referencia
if [ ! -f "$MARCA" ]; then
    echo "No hay copia total previa; ejecuta total.sh primero." >&2
    exit 1
fi

# Se trabaja sobre una COPIA de la marca para no modificar la de la total
# (asi todas las diferenciales se comparan siempre con la total)
TMP="$(mktemp)"
cp "$MARCA" "$TMP"
tar --listed-incremental="$TMP" -czf "$DEST/CopDifSem-$(date +%V).tar.gz" /home 2>/dev/null
rm -f "$TMP"
