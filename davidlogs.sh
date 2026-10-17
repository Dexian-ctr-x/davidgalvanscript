#!/bin/bash

# Función: muestra cómo se usa el script
uso() {
    echo "Uso: $0 <emergente|alerta|crítico|error|advertencia|noticia|información|depuración>"
}
# traduce el nivel a su prioridad de journalctl.
# Devuelve el número con echo, y return 1 si el nivel no es válido.
prioridad() {
    case "$1" in
        emergente)                 echo 0 ;;
        alerta)                    echo 1 ;;
        crítico|critico)           echo 2 ;;
        error)                     echo 3 ;;
        advertencia)               echo 4 ;;
        noticia)                   echo 5 ;;
        información|informacion)   echo 6 ;;
        depuración|depuracion)     echo 7 ;;
        *)                         return 1 ;;
    esac
}

# Validar el número de parámetros
if [ $# -ne 1 ]; then
    echo "Error: se necesita exactamente un parámetro."
    uso
    exit 1
fi

# Validar el nivel recibido
prio=$(prioridad "$1")
if [ $? -ne 0 ]; then
    echo "Error: nivel '$1' no válido."
    uso
    exit 1
fi

inicio=$(date +%Y-%m-01)
archivo="$HOME/registros_$1_$(date +%Y-%m).log"

# Generar el listado del nivel exacto (prio..prio) desde el día 1 del mes
journalctl -p "$prio..$prio" --since "$inicio" --no-pager -q > "$archivo"
if [ $? -ne 0 ]; then
    echo "Error: no se pudo leer el diario del sistema (¿faltan permisos?)."
    exit 2
fi

cantidad=$(wc -l < "$archivo")

echo "Registros de nivel '$1' de este mes: $cantidad"
echo "Listado guardado en: $archivo"