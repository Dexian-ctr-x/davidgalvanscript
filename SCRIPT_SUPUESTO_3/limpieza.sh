#!/bin/bash
# Script: limpieza.sh  (anacron, mensual)
# Elimina SOLO las copias diferenciales. Las totales (CopTot-*) no se tocan.
rm -f /bacDavidG/CopDifSem-*.tar.gz
