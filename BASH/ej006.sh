#!/bin/bash
echo "Calculadora secuencial"
read -p "Ingrese el primer número:" a
read -p "Ingrese el segundo número:" b
suma=$(($a + $b))
resta=$(($a - $b))
multiplicacion=$(($a * $b))
if [ $b -ne 0 ]; then
    division=$(($a / $b))
else
    division="Error: División por cero"
fi