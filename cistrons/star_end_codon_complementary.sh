#!/bin/bash

#./star_end_codon_complementary.sh secuencia.fasta

start_codon="CAT"
stop_codons=("TTA" "CTA" "TCA")

fasta_sequence=$1
results_false="results/results_false/results_false.txt"

cantidad_lineas=$(wc -l < "$results_false")

echo "*          Verificando codones de inicio y fin...             *"
echo "*          Procesando...                                      *"

for ((i = 1; i <= cantidad_lineas; i++)); do
    {
        grep -w "g${i}" "$results_false" | awk -v sequence="$fasta_sequence" -v start="$start_codon" '{
            if ($3=="start_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7" | grep -c "start"") > 0){
                cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7
                cmd | getline sequence_result
                cmd | getline sequence_result
                close(cmd)
                print $1 " | " $3 " | " $5 " - " $7 " | " sequence_result " | false"
            } else if ($3=="start_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7" | grep -v -c "start"") == 0){
                cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7
                cmd | getline sequence_result
                cmd | getline sequence_result
                close(cmd)
                print $1 " | " $3 " | " $5 " - " $7 " | " sequence_result " | true"
            }
        }'

        grep -w "g${i}" "$results_false" | awk -v sequence="$fasta_sequence" -v stops="${stop_codons[*]}" 'BEGIN {split(stops, stops_array, " ")}{
        for (i = 1; i <= length(stops_array); i++) {
            if ($3=="stop_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7" | grep -c -w \"" stops_array[i] "\"") > 0){
                cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7
                cmd | getline sequence_result
                cmd | getline sequence_result
                close(cmd)
                print $1 " | " $3 " | " $5 " - " $7 " | " sequence_result " | false"
            } else if ($3=="stop_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7" | grep -v -c -w \"" stops_array[i] "\"") == 0) {
                cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$5"-"$7
                cmd | getline sequence_result
                cmd | getline sequence_result
                close(cmd)
                print $1" | " $3" | " $5 " - " $7 " | " sequence_result " | true"
            }   
        }
    }'

    } >>temp.txt

    if (($i == $cantidad_lineas / 2)); then
        echo "*          Terminando el procesamiento...                     *"
        break
    fi
done

sed -i -e 's/^1$//g' -e 's/^0$//g' temp.txt
sed -i '/^$/d' temp.txt

awk '!seen[$0]++ && (/true$/ && /stop_codon/) || (/start_codon/ && /true$/)' temp.txt > results/results_true/results_true_complementary.txt
awk -F " \| " '!seen[$0]++ && (/false$/ && /stop_codon/ && $4 != "TTA" && $4 != "CTA" && $4 != "TCA")|| (/start_codon/ && /false$/)' temp.txt > results/results_false/results_false_complementary.txt

rm temp.txt

echo "Resultados preliminares usados: $results_false"
echo "Secuencia base: $fasta_sequence"

echo "*          Proceso finalizado.                                *"
