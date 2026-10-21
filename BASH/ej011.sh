#!/bin/bash
read -p "Introduce el nombre de un fichero: " fichero

ls -lh "$fichero"
file "$fichero"