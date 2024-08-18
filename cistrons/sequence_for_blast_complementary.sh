#!/bin/bash

#./sequence_for_blast.sh secuencia_fasta
preliminar_results="results/results_true/results_true_complementary.txt"
fasta_sequence=$1

conjunto_genes=$(awk -F\" '{print $2}' "$preliminar_results")
lista_genes=$(printf "%s\n" "${conjunto_genes[@]}")
# Eliminar duplicados
conjunto_genes=($(echo "$lista_genes" | awk '!seen[$0]++'))

echo "*          Extrayendo secuencias...                           *"

for gen in ${conjunto_genes[@]}
do
    final=$(grep -w "$gen" "$preliminar_results" | awk '{if ($3=="start_codon") print $7 }')
    inicio=$(grep -w "$gen" "$preliminar_results" | awk '{if ($3=="stop_codon") print $5 }')
    samtools faidx $fasta_sequence IdDeTuArchivoFasta:"$inicio"-"$final" >> results/results_true/cistrons_with_codons_in_false.fasta
    samtools faidx $fasta_sequence IdDeTuArchivoFasta:"$inicio"-"$final" | python3 python/complement_sequence.py >> results/results_true/cistrons_complementary.fasta
    samtools faidx $fasta_sequence IdDeTuArchivoFasta:"$inicio"-"$final" | python3 python/complement_reverse_sequence.py >> results/results_true/cistrons_complementary_reverse.fasta
done

echo "Coordenadas del gen: $preliminar_results"
echo "Secuencia base: $fasta_sequence"

echo "*          Extracción exitosa.                                *"