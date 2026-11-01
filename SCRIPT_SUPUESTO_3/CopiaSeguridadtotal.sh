#!/bin/bash
# Script: total.sh  (anacron, mensual)
# Copia de seguridad TOTAL de /home. Nombre: CopTot-<mes completo>-<año completo>
# Borra la marca anterior para que la copia sea completa (nivel 0).
DEST=/bacDavidG
MARCA="$DEST/.marca_total.snar"      # marca con el estado de los ficheros en la copia total

rm -f "$MARCA"
tar --listed-incremental="$MARCA" -czf "$DEST/CopTot-$(date +%B-%Y).tar.gz" /home 2>/dev/null
