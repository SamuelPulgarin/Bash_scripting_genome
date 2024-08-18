# PREPARAR ENTORNO:

- Asegurese que el script principal **START.sh** tenga permisos de administrador para crear, modificar, eliminar archivos y carpetas.

- Agregue el identificador de su archivo fasta a los siguientes scripts:
    - star_end_codon.sh
    - star_end_codon_complementary.sh
    - sequence_for_blast.sh
    - sequence_for_blast_complementary.sh
    
- Reemplaze la palabra "IdDeTuArchivoFasta" por el identificador de su archivo fasta en los scripts mencionados anteriormente.

- AVISO: No olvide que el archivo fasta principal, debe contener un solo identificador para toda la secuencia ">unicoIdentificador".


# PAQUETES USADOS (python):

## pip install biopython
[Source](https://biopython.org/wiki/Documentation)

*NOTA*: Si presenta problemas con el paquete y las importaciones de python, por favor dirijase hacia la penúltima sección de este archivo.


# SCRIPTS: Funcionamiento

## START.sh
Script principal encargado de ejecutar todos los demás scripts. 
      
X: Se debe ejecutar de la la siguiente forma:
``` ./START.sh output_augustus_file archivo_fasta ```


## star_end_codon.sh
Es el primer script en ejecutarse. Se encarga de verificar que el codon de inicio-final de los genes encontrados por augustus sean veridicos con respecto a los siguientes codones:

### codones de inicio: 
ATG

### codones de terminación: 
TAA TAG TGA

El script almacenará los resultados de la siguiente manera:

### results_true.txt: 
Archivo donde se guardarán los genes que cuyo codones de inicio y de cierre COINCIDAN con los codones de inicio especificados.

### results_false.txt: 
Archivo donde se guardarán los genes que cuyo codones de inicio y de cierre NO COINCIDAN con los codones de terminación especificados.
    
X: Si desea ejecutar de manera individual, se debe ejecutar el script de la siguiente forma: 
``` ./star_end_codon output_augustus_file archivo_fasta ```


## star_end_codon_complementary
Script opcional encargado de analizar los resultados en false del archivo **results_false.txt** y verificar que el codon de inicio-final de los genes encontrados por augustus sean veridicos con respecto a los siguientes codones:

### codones de inicio: 
CAT
### codones de terminación: 
TTA TCA CTA

El script almacenará los resultados de la siguiente manera:

### results_true_complementary.txt: 
Archivo donde se guardarán los genes cuyo codones de inicio y de cierre COINCIDAN con los codones de inicio especificados.

### results_false_complementary.txt: 
Archivo donde se guardarán los genes que cuyo codones de inicio y de cierre NO COINCIDAN con los codones de terminación especificados.

X: Si desea ejecutar de manera individual, se debe ejecutar el script de la siguiente forma:
``` ./star_end_codon_complementary archivo_fasta ```


## sequence_for_blast.sh
Script encargado de extraer las secuencias de interés del archivo **results_true.txt**

El script almacenará las secuencias de la siguinete manera:

### cistrons_with_codons_in_true.fasta: 
Archivo en formato fasta formado por la función **samtools faidx** que almacena todas las secuencias de interés ligadas a su identificador(coordenadas).

X: Si desea ejecutar de manera individual, se debe ejecutar el script de la siguiente forma:
``` ./sequence_for_blast.sh archivo_fasta ```


## sequence_for_blast_complementary.sh
Script opcional encargo de extraer las secuencias de interés del archivo **results_false.txt**

El script almacenará las secuencias de la siguiente manera:

### cistrons_with_codons_in_false.fasta: 
Archivo en formato fasta formado por la función **samtools faidx** que almacena todas las secuencias de interés ligadas a su identificador (coordenadas).

### cistrons_complementary.fasta: 
Archivo en formato fasta formado por la función  **samtools faidx** que almacena todas las secuencias complementarias (ADNc) de interés ligadas a su identificador (coordenadas).

### complement_sequence.py: 
Script escrito en python encargado de unir los nucleotidos de la secuencia ADN con sus contrapartes, recibe la salida de **samtools faidx** dentro del ciclo y devuelve la cadena con su complementariedad.

### cistrons_complementary_reverse.fasta: 
Archivo en formato fasta formado por la función **samtools faidx** que almacena todas las secuencias complementarias (ADNc) al revés, cada una ligada a su identificador (coordenadas).

### complement_reverse_sequence.py: 
Script escrito en python encargado de unir los nucleotidos de la secuencia ADN con sus contra partes y revertir la secuencia, recibe la salida de **samtools faidx** dentro del ciclo y devuelve la cadena con su complementariedad al revés.

X: Si desea ejecutar de manera individual, se debe ejecutar el script de la siguiente forma:
``` ./sequence_for_blast_complementary.sh archivo_fasta ```


## format_reverse_sequence.sh
Script encargado de formatear la salida del archivo **cistrons_complementary_reverse.fasta** 
       
El archivo cistrons_complementary_reverse.fasta aunque contiene las secuencias ADN con sus contra partes y a la inversa, los identificadores están en posiciones incorrectas y el formato de las secuencias no es el más optimo; es por ello que se requiere de un script para formatear el archivo correctamente.

X: Si desea ejecutar de manera individual, se debe ejecutar el script de la siguiente forma:
``` ./format_reverse_sequence.sh ```


# PROBLEMAS CON LA SUIT DE SCRIPTS

*ERROR*: Reference :x-y not found in FASTA file, returning empty sequence

*SOLUCIÓN 1*: 
Verifique que los codones estén correctamente escritos en los siguientes archivos:
``` results/results_true/results_true.txt ```
``` results/results_false/results_false.txt ```

De no ser así, por favor elimine todos los directorios y archivos generados por la suit y ejecute nuevamente.

*SOLUCIÓN 2*:
Asegurese de reemplazar la palabra "IdDeTuArchivoFasta" por el identificador de su archivo fasta en los siguientes scripts:
- star_end_codon.sh
- star_end_codon_complementary.sh
- sequence_for_blast.sh
- sequence_for_blast_complementary.sh


# PROBLEMAS CON EL ENTORNO VIRTUAL

Primero asegurese de tener instalado los siguientes recursos necesarios:
``` sudo apt update ```
``` sudo apt install python3-pip ```
``` sudo apt install python3.10-venv ```

Posteriormente debe crear un entorno virtual para las librerías
``` python3 -m venv myenv ```

Debe acceder al entorno virtual de la siguiente manera:
``` source myenv/bin/activate ```

Finalmente puede instalar y hacer uso de los paquetes que usted requiera:
``` pip install biopython ```


# FORMATO DEL ARCHIVO README

    # Caracter utilizado para representar secciones (títulos) al interior del archivo.

    ## Caracter utilizado para representar sub-secciones (subtítulos) al interior del archivo.

    ### Caracter utilizado para representar sub-subtítulos al interior del archivo.

    - Caracter utiizado para representar elementos de una lista.

    ``` Caracteres usados para mostrar comandos.

    X: Caracter utilizado para representar el como se ejecuta un script.



      
      
      