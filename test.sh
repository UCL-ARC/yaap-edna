#!/bin/bash

#
# test that all of the tools can print their help message
#

#activate the conda environment
#not sure why conda init is not able to setup conda properly on myriad
#but this method is a workaround
source "/lustre/home/ccaervi/miniforge3/etc/profile.d/conda.sh"
conda activate yaap

test_command() {
    CMD=$1
    echo
    echo " ==== ${CMD} ==== "
    if [[ "${CMD}" != "usearch" ]] ; then
        CMD="${CMD} -h"
    fi
    ${CMD} | head -n 6
}

for CMD in \
    cutadapt \
    vsearch \
    seqkit \
    usearch \
    pear ;
do
    test_command $CMD
done

#copy across test data
rsync -a ccaervi@rdp-ssh.arc.ucl.ac.uk:/rdss/rd01/ritd-ag-project-rd01t5-jlitt26/test* .
