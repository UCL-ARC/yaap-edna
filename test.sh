#!/bin/bash

#
# test that all of the tools can print their help message
#

set -eu

#activate the conda environment
#not sure why conda init is not able to setup conda properly on myriad
#but this method is a workaround
source "/lustre/home/$(whoami)/miniforge3/etc/profile.d/conda.sh"
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

#create a workspace folder and change into it
export WORKSPACE_DIR=~/littlefair_workspace

mkdir -p ${WORKSPACE_DIR} && cd ${WORKSPACE_DIR}

#copy across test data
rsync -a ccaervi@rdp-ssh.arc.ucl.ac.uk:/rdss/rd01/ritd-ag-project-rd01t5-jlitt26/test* .

#remove space from test folder name
mv ./test\ _for_Rob_ARCs/ ./test_for_Rob_ARCs/
