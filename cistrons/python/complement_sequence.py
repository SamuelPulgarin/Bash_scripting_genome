import os
import sys

from Bio.Seq import Seq

# Secuencia de la entrada estándar
secuencia = sys.stdin.read().strip()

print(str(Seq(secuencia).complement()))