#!/bin/bash
echo "Copia del archivo passwd"
cp /etc/passwd /home/zerpa/copia_passwd.txt
echo "Se ha copiado el archivo passwd a la carpeta home con el nombre copia_passwd.txt."
ls -l /home/zerpa/copia_passwd.txt
du -h /home/zerpa/copia_passwd.txt
