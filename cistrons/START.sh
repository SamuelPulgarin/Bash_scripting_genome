#!/bin/bash

# BLUE='\033[0;34m'
# NC='\033[0m'

augustus_gene_predict_file=$1
fasta_sequence=$2

echo "***************************************************************"
./star_end_codon.sh $augustus_gene_predict_file $fasta_sequence
echo "***************************************************************"

echo "¿Desea examinar también los resultados en false? Si=1 | No=0"
read false_results

if [ "$false_results" -ne 0 ]; then
    echo "***************************************************************"
    ./star_end_codon_complementary.sh $fasta_sequence
    echo "***************************************************************"
fi

echo "***************************************************************"
./sequence_for_blast.sh $fasta_sequence
echo "***************************************************************"

if [ "$false_results" -ne 0 ]; then
    echo "¿Desea extraer también las secuencias complementarias? Si=1 | No=0"
    read results_true_complementary
    if [ "$results_true_complementary" -ne 0 ]; then
        echo "***************************************************************"
        ./sequence_for_blast_complementary.sh $fasta_sequence
        echo "***************************************************************"
        ./format_reverse_sequence.sh
        echo "***************************************************************"
    fi
fi

echo "***************************************************************"
echo "*          ¡Labores finalizadas!                              *"
echo "*          Gracias por usar nuestros servicios.               *"
echo "***************************************************************"



