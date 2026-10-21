#!bin/bash
#Datos de la máquina
echo "Nombre de la máquina: $(hostname)"
echo "Usuarios conectados actualmente: $(who | wc -l)"
echo "Version del kernel: $(uname -r)"