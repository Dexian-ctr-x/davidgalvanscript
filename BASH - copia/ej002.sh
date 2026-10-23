#!/bin/bash
echo "¿Quién  y dónde"
echo "-------------INFORMACIÓN DEL SISTEMA-------------"
echo "Nombre del equipo: $(hostname)"
echo "Sistema operativo: $(uname -o)"
echo "Usuario actual: $(whoami)"
echo "Fecha y hora actual: $(date)"
echo "Directorio actual: $(pwd)"
echo "--------------------------------------------------"