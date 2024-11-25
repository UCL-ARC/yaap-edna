#!/bin/bash

#
# test that all of the tools can print their help message
# run the pipeline on the test data
#

set -eu

test_command() {
    CMD=$1
    echo
    echo " ==== ${CMD} ==== "
    if [[ "${CMD}" != "usearch" ]] ; then
        CMD="${CMD} -h"
    fi
    ${CMD} | head -n 6
}

export WORKSPACE_DIR=~/littlefair_workspace
export REPO_DIR=~/repos/yaap-edna

#not sure why conda init is not able to setup conda properly on myriad
#but this method is a workaround
source ~/miniforge3/etc/profile.d/conda.sh

#activate the conda environment
conda activate yaap

#test all tools can be found (requires visual inspection to check they worked!)
for CMD in cutadapt vsearch seqkit usearch pear ; do
    test_command $CMD
done

conda deactivate

#create a workspace folder and change into it
mkdir -p ${WORKSPACE_DIR}
cd ${WORKSPACE_DIR}

#copy across test data from RDP
rsync -a ccaervi@rdp-ssh.arc.ucl.ac.uk:/rdss/rd01/ritd-ag-project-rd01t5-jlitt26/test\ _for_Rob_ARCs .

#remove space from test folder name
mv ./test\ _for_Rob_ARCs/ ./test_for_Rob_ARCs/

#generate master checksum of all data here and on RDP for comparison
cd test_for_Rob_ARCs/mam
ssh ccaervi@rdp-ssh.arc.ucl.ac.uk 'cd /rdss/rd01/ritd-ag-project-rd01t5-jlitt26/test\ _for_Rob_ARCs/mam  && find . -type f -exec md5sum {} \; | sort | md5sum'
find . -type f -exec md5sum {} \; | sort | md5sum

#create filelist
ls -1 | sed 's/_R[12]\.fastq\.gz//' | sort -u > readsmam.list

qsub ${REPO_DIR}/yaap_submit_mam.sh
