#!/bin/bash
# Fichero con contenido
touch /script/notas.txt
echo "Primera linea de texto" >> /script/notas.txt
echo "Srgunda linea de texto" >> /script/notas.txt
echo "Tercera linea de texto" >> /script/notas.txt

cat -n  /script/notas.txt