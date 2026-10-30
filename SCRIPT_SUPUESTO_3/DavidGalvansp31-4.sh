#!/bin/bash
# Script: DavidGalvansp31-4.sh
# Desinstala los programas escritos en programas.txt (uno por linea).
# Funciona con programas instalados con apt (.deb) y con snap
# (el Centro de aplicaciones de Ubuntu instala snaps).
# programas.txt debe estar en el mismo directorio que este script.
# Uso: sudo ./DavidGalvansp31-4.sh

# Directorio donde esta el script (asi funciona se ejecute desde donde se ejecute)
DIR="$(cd "$(dirname "$0")" && pwd)"
LISTA="$DIR/programas.txt"

# Hay que ser root para desinstalar programas
if [ "$EUID" -ne 0 ]; then
    echo "Ejecuta el script con sudo."
    exit 1
fi

# Comprobamos que existe el fichero con la lista
if [ ! -f "$LISTA" ]; then
    echo "No existe el fichero $LISTA"
    exit 1
fi

echo "Leyendo la lista de programas de $LISTA"
echo "----------------------------------------"

# Leemos el fichero linea a linea (cada linea es un programa)
while read -r programa || [ -n "$programa" ]; do

    # Quitamos retornos de carro (por si el fichero viene de Windows) y espacios
    programa=$(echo "$programa" | tr -d '\r' | xargs)

    # Si la linea esta vacia, pasamos a la siguiente
    if [ -z "$programa" ]; then
        continue
    fi

    # Caso 1: instalado con apt (dpkg -s lo comprueba)
    if dpkg -s "$programa" 2>/dev/null | grep -q "Status: install ok installed"; then
        echo ">> Desinstalando $programa (apt) ..."
        if apt-get purge -y "$programa" > /dev/null 2>&1; then
            echo "   OK: $programa desinstalado."
        else
            echo "   ERROR: no se pudo desinstalar $programa."
        fi

    # Caso 2: instalado como snap (snap list lo comprueba)
    elif command -v snap > /dev/null 2>&1 && snap list "$programa" > /dev/null 2>&1; then
        echo ">> Desinstalando $programa (snap) ..."
        if snap remove --purge "$programa" > /dev/null 2>&1; then
            echo "   OK: $programa desinstalado."
        else
            echo "   ERROR: no se pudo desinstalar $programa."
        fi

    # Caso 3: no esta instalado de ninguna forma: avisamos y seguimos
    else
        echo "!! $programa no esta instalado. Paso al siguiente."
    fi

done < "$LISTA"

# Limpiamos dependencias de apt que ya no hacen falta
echo "----------------------------------------"
echo "Limpiando dependencias sobrantes..."
apt-get autoremove -y > /dev/null 2>&1
echo "Proceso terminado."
