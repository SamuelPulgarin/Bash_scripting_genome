#!/bin/bash

#./star_end_codon archivo_augustus secuencia.fasta

start_codon="ATG"
stop_codons=("TAA" "TAG" "TGA")

augustus_gene_predict_file=$1
fasta_sequence=$2

grep -e "start_codon" -e "stop_codon" < "$augustus_gene_predict_file" > codones.txt

cantidad_lineas=$(wc -l < codones.txt)

samtools faidx "$fasta_sequence"

echo "*          Verificando codones de inicio y fin...             *"
echo "*          Procesando...                                      *"

for ((i = 1; i <= cantidad_lineas / 2; i++))
do
    {
        grep -w "g${i}" codones.txt | awk -v sequence="$fasta_sequence" -v start="$start_codon" -v header="$header" '{
        if ($3=="start_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5" | grep -c "start"") > 0){
            cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5
            cmd | getline sequence_result
            cmd | getline sequence_result
            close(cmd)
            print $12 " | " $3 " | " $4 " - " $5 " | " sequence_result " | false"
        } else if ($3=="start_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5" | grep -v -c "start"") == 0){
            cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5
            cmd | getline sequence_result
            cmd | getline sequence_result
            close(cmd)
            print $12 " | " $3 " | " $4 " - " $5 " | " sequence_result " | true"
        }
    }'

        grep -w "g${i}" codones.txt | awk -v sequence="$fasta_sequence" -v stops="${stop_codons[*]}" 'BEGIN {split(stops, stops_array, " ")}{
        for (i = 1; i <= length(stops_array); i++) {
            if ($3=="stop_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5" | grep -c -w \"" stops_array[i] "\"") > 0){
                cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5
                cmd | getline sequence_result
                cmd | getline sequence_result
                close(cmd)
                print $12 " | " $3 " | " $4 " - " $5 " | " sequence_result " | false"
            } else if ($3=="stop_codon" && system("samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5" | grep -v -c -w \"" stops_array[i] "\"") == 0) {
                cmd = "samtools faidx " sequence " "IdDeTuArchivoFasta":"$4"-"$5
                cmd | getline sequence_result
                cmd | getline sequence_result
                close(cmd)
                print $12 " | " $3 " | " $4 " - " $5 " | " sequence_result " | true"
            }   
        }
    }'
    } >> temp.txt

    if (( $i == $cantidad_lineas / 2 )); then
        echo "*          Terminando el procesamiento...                     *"
        break
    fi
done

sed -i -e 's/^1$//g' -e 's/^0$//g' temp.txt
sed -i '/^$/d' temp.txt

mkdir -p results
mkdir -p results/results_true
mkdir -p results/results_false

awk '!seen[$0]++ && (/true$/ && /stop_codon/) || (/start_codon/ && /true$/)' temp.txt > results/results_true/results_true.txt
awk -F " \| " '!seen[$0]++ && (/false$/ && /stop_codon/ && $4 != "TAA" && $4 != "TAG" && $4 != "TGA")|| (/start_codon/ && /false$/)' temp.txt > results/results_false/results_false.txt

rm temp.txt
rm codones.txt

echo "Anotación estructural: $augustus_gene_predict_file"
echo "Secuencia base: $fasta_sequence"

echo "*          Proceso finalizado.                                *"

