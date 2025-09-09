#! /bin/bash

padron_entrada=$1
directorio_entrada="./resultado"

mkdir -p "$directorio_entrada"
./parte_1.sh "$padron_entrada" "$directorio_entrada"

./parte_2.sh "$directorio_resultado"/resultado.txt > "$directorio_entrada"/output.txt
