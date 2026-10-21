#!bin/bash
ls -l /etc > listado.txt
ls -l /root > /dev/null 2> errores.txt
wc -l listado.txt errores.txt