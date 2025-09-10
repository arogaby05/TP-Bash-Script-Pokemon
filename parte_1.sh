#! /bin/bash
padron=$1
directorio=$2

clase_de_pokemon=$(( $padron % 18 + 1 ))
habilidad_pokemon=$(( $padron % 100 + 350 ))

echo "Tipo de pokemon: $clase_de_pokemon"
echo "Estadística mínima: $habilidad_pokemon"

localizar_archivos_csv(){
    local archivo_csv="$1"
    find . -type f -name "*$archivo_csv*" | head -n 1
}

filtrar_pokemon_por_clase(){
    local ruta_archivo_csv="$1"
    while IFS=',' read -r pokemon_id type_id_csv slot_csv; do
        if [[ "$type_id_csv" -eq "$clase_de_pokemon" ]]; then
            echo "$pokemon_id"
        fi
    done < "$ruta_archivo_csv"
}

filtrar_pokemon_por_estadistica_minima(){
    local ruta_archivo_csv="$1"
    awk -F',' -v estadistica_minima="$habilidad_pokemon" '{
        estadistica[$1]+=$3
    } END {
        for (pokemon_id in estadistica){
            if (estadistica[pokemon_id] >= estadistica_minima){
                print pokemon_id
            }
        }
    }' "$ruta_archivo_csv"
}

cruzar_ids(){
    local lista1_id="$1"
    local lista2_id="$2"
    while IFS= read -r id; do
        if grep -q -F -x "$id" <<< "$lista2_id"; then
            echo "$id"
        fi
    done <<< "$lista1_id"
}

convertir_id_a_nombre(){
    while IFS= read -r id; do
        grep -E "^${id}," "$ARCHIVO_POKEMON_CSV" | cut -d ',' -f2
    done <<< "$cruce_id" 
}

ARCHIVO_TIPOS_CSV=$(localizar_archivos_csv "pokemon_types.csv")
ARCHIVO_ESTADISTICA_CSV=$(localizar_archivos_csv "pokemon_stats.csv")
ARCHIVO_POKEMON_CSV=$(localizar_archivos_csv "pokemon.csv")

for csv in "$ARCHIVO_TIPOS_CSV" "$ARCHIVO_ESTADISTICA_CSV" "$ARCHIVO_POKEMON_CSV"; do
    if [[ ! -f "$csv" ]]; then
        echo "No se encontró $csv"
        exit 1
    fi
done

mkdir -p "$directorio"

clase_de_pokemon_id=$(filtrar_pokemon_por_clase "$ARCHIVO_TIPOS_CSV")
estadistica_pokemon_id=$(filtrar_pokemon_por_estadistica_minima "$ARCHIVO_ESTADISTICA_CSV")
cruce_id=$(cruzar_ids "$clase_de_pokemon_id" "$estadistica_pokemon_id")
nombre_pokemon=$(echo "$cruce_id" | convertir_id_a_nombre)

echo "$nombre_pokemon" > "$directorio/resultado.txt"


