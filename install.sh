#!/bin/bash

#
# Rob Vickerstaff 2024-10-04
# following https://github.com/ilevantis/YAAP?tab=readme-ov-file#installation
# see https://github.com/UCL-ARC/yaap-edna
#

set -eu

#install miniforge
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh

# grab the conda environment specification file
wget https://raw.githubusercontent.com/ilevantis/YAAP/master/yaap_env.yml

# install the specified dependencies with conda
conda env create -f yaap_env.yml

# download and setup usearch 32 bit binary
wget https://www.drive5.com/downloads/usearch11.0.667_i86linux32.gz
gunzip usearch11.0.667_i86linux32.gz
chmod +x usearch11.0.667_i86linux32
mkdir -p ~/bin
mv -f usearch11.0.667_i86linux32 ~/bin
cd ~/bin
ln -s usearch11.0.667_i86linux32 usearch

# download and set up the main pipeline script
wget 'https://raw.githubusercontent.com/ilevantis/YAAP/master/ASV_pipeline.sh'
chmod +x ASV_pipeline.sh
cd -
