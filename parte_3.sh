#! /bin/bash

padron_entrada=$1
directorio_entrada="./resultado"

if [ -z "$padron_entrada" ]; then
   echo "Usar $0 con <PADRON>"
   exit 1
fi

mkdir -p "$directorio_entrada"
./parte_1.sh "$padron_entrada" "$directorio_entrada"

if [ ! -f "$directorio_entrada/resultado.txt" ]; then
   echo "No se encontró $directorio_entrada/resultado.txt"
   exit 1
fi

./parte_2.sh < "$directorio_entrada"/resultado.txt > "$directorio_entrada/output.txt"
