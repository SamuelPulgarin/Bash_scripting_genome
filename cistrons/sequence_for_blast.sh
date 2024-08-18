#!/bin/bash

#./sequence_for_blast.sh secuencia_fasta

preliminar_results="results/results_true/results_true.txt"
fasta_sequence=$1

conjunto_genes=$(awk -F\" '{print $2}' "$preliminar_results")
lista_genes=$(printf "%s\n" "${conjunto_genes[@]}")
# Eliminar duplicados
conjunto_genes=($(echo "$lista_genes" | awk '!seen[$0]++'))

echo "*          Extraer secuencias de interes...                   *"
echo "*          Extrayendo secuencias...                           *"

for gen in ${conjunto_genes[@]}
do
    inicio=$(grep -w "$gen" "$preliminar_results" | awk '{if ($3=="start_codon") print $5 }')
    final=$(grep -w "$gen" "$preliminar_results" | awk '{if ($3=="stop_codon") print $7 }')
    samtools faidx $fasta_sequence IdDeTuArchivoFasta:"$inicio"-"$final" >> results/results_true/cistrons_with_codons_in_true.fasta
done

echo "Coordenadas tomadas de: $preliminar_results"
echo "Secuencia base: $fasta_sequence"

echo "*          Extracción exitosa.                                *"