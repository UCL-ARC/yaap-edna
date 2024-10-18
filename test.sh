#!/bin/bash

set -eu

#not sure why conda init is not able to setup conda properly on myriad
#but this method is a workaround
source "/lustre/home/ccaervi/miniforge3/etc/profile.d/conda.sh"

conda activate yaap
cutadapt -h
vsearch -h
seqkit -h
usearch
pear -h
