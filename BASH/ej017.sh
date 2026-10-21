#!bin/bash

if [ $# -ne 2 ]; then
    echo "Uso: $0 palabra1 palabra2" >&2
    exit 1
fi

echo "$2 $1"