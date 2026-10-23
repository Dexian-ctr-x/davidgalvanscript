#!bin/bash
read -p "Introduce tu año de nacimiento: " nacimiento
actual=$(date +%Y)
edad=$((actual - nacimiento))
echo "Año actual: $actual"
echo "Tu edad aproximada es de $edad años."