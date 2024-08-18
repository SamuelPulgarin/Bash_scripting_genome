#!/bin/bash

# Nombre del archivo de entrada y salida
archivo_entrada="results/results_true/cistrons_complementary_reverse.fasta"
archivo_salida="results/results_true/cistrons_complementary_revers.fasta"

# Verifica que el archivo de entrada exista
if [ ! -f "$archivo_entrada" ]; then
    echo "Error: El archivo de entrada '$archivo_entrada' no existe."
    exit 1
fi

# Limpia el archivo de salida si ya existe
> "$archivo_salida"

escribir_secuencia() {
    local secuencia="$1"
    local longitud_linea="$2"
    local i
    for ((i = 0; i < ${#secuencia}; i += longitud_linea)); do
        echo "${secuencia:$i:$longitud_linea}" >> "$archivo_salida"
    done
}

# Inicializa la variable para almacenar el encabezado y secuencia
encabezado=""
secuencia=""
bandera=""

echo "* Formateando archivo fasta: cistrons_complementary_reverse...*"

# Lee el archivo de entrada línea por línea
while IFS= read -r linea || [[ -n "$linea" ]]; do
    # Si la línea contiene ">", es el inicio de un nuevo encabezado
    if [[ $linea == *">" ]]; then

        # Guardar y voltear el encabezado
        encabezado="$linea"
        encabezado_invertido=$(echo "$linea" | rev)

        # Si no es el primer encabezado, escribe el encabezado invertido seguido de la secuencia en el archivo de salida
            echo "$encabezado_invertido" >> "$archivo_salida"
            escribir_secuencia "$secuencia" 60  # Longitud de línea deseada
            bandera="Save Point"

        if [ -n "$bandera" ]; then
            secuencia=""
        fi

    else
        # Si no es un encabezado, es parte de la secuencia, concaténala
        secuencia="$secuencia$linea"
    fi
done < "$archivo_entrada"

rm $archivo_entrada

echo "secuencias formateadas y escritas en '$archivo_salida'"
