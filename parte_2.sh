#! /bin/bash

localizar_archivos_csv(){
    local archivo_csv="$1"
    find . -type f -name "$archivo_csv" | head -n 1
}

buscar_pokemon(){
    local nombre_pokemon="$1"
    grep -i ",$nombre_pokemon," "$ARCHIVO_POKEMON_CSV" | while IFS=',' read -r id identifier rest; do
        if [[ "$identifier" == "$nombre_pokemon" ]]; then
            echo "$id,$identifier,$rest"
            break
        fi
    done   
}

mostrar_caracteristica_pokemon(){
    local nombre_pokemon="$1"
    local linea

    linea=$(buscar_pokemon "$nombre_pokemon")
    if [ -z "$linea" ]; then
        echo "----------------------"
        echo "Pokemon: $nombre_pokemon"
        echo "(Pokemon no encontrado)"
        echo "----------------------"
        return
    fi

    local pokemon_id altura_dm peso_hg altura_cm peso_kg
    pokemon_id=$(echo "$linea" | cut -d ',' -f1)
    altura_dm=$(echo "$linea" | cut -d ',' -f4)
    peso_hg=$(echo "$linea" | cut -d ',' -f5)

    altura_cm=$((altura_dm * 10))
    peso_kg=$((peso_hg / 10))

    echo "----------------------"
    echo "Pokemon: $nombre_pokemon"
    echo "Altura: $altura_cm centímetros"
    echo "Peso: $peso_kg kilos"
    echo
    echo "Habilidades:"
    lista_habilidades_pokemon "$pokemon_id"
    echo "----------------------"
}

lista_habilidades_pokemon(){
    local pokemon_id="$1"
    grep -E "^$pokemon_id" "$ARCHIVO_HABILIDADES_CSV" | cut -d ',' -f2 | while read -r habilidad_id; do
        habilidad=$(grep "^$habilidad_id,7," "$ARCHIVO_NOMBRE_HABILIDADES_CSV" | cut -d ',' -f3)
        if [ -n "$habilidad" ]; then
            echo " * $habilidad"
        fi
    done
}

ARCHIVO_POKEMON_CSV=$(localizar_archivos_csv "pokemon.csv")
ARCHIVO_HABILIDADES_CSV=$(localizar_archivos_csv "pokemon_abilities.csv")
ARCHIVO_NOMBRE_HABILIDADES_CSV=$(localizar_archivos_csv "ability_names.csv")

for csv in "$ARCHIVO_POKEMON_CSV" "$ARCHIVO_HABILIDADES_CSV" "$ARCHIVO_NOMBRE_HABILIDADES_CSV"; do
    if [ ! -f "$csv" ]; then
        echo "No se encontró $csv" >&2
        exit 1
    fi
done

while read -r nombre_pokemon; do
    if [ -n "$nombre_pokemon" ]; then
        mostrar_caracteristica_pokemon "$nombre_pokemon"
    fi
done
