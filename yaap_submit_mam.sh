#!/bin/bash
#$ -cwd
#$ -pe smp 12
#$ -l h_rt=12:0:0
#$ -l h_vmem=2G
#$ -m e

source ~/miniforge3/etc/profile.d/conda.sh
conda activate yaap
export PATH=${PATH}:~/bin

# Pipeline  requires 9 arguments:
# 1. File with a list of fileset prefix (one per line)
# 2. Forward primer sequence
# 3. Reverse primer sequence
# 4. Primer name
# 5. Prefix of the output
# 6. Number of cpus to use
# 7. Minimum amplicon length
# 8. Maximum amplicon length
# 9. Unoise minimum abundance parameter

# the following is all one line:
ASV_pipeline.sh readsmam.list CGGTTGGGGTGACCTCGGA GCTGTTATCCCTAGGGTAACT mam16S mam16S 12 70 110 4

