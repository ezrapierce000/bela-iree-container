#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
chmod +x ./Miniconda3-py39_4.12.0-Linux-x86_64.sh
./Miniconda3-py39_4.12.0-Linux-x86_64.sh -b

source /root/miniconda3/bin/activate

yes | CONDA_SUBDIR=linux-64 conda create -n zoo-tf -c conda-forge python pip fire tensorflow
conda activate zoo-tf
conda config --env --set subdir linux-64
yes | CONDA_SUBDIR=linux-64 conda create -n zoo -c conda-forge python pip fire jax
conda activate zoo
conda config --env --set subdir linux-64

cd /opt
git clone https://github.com/iree-org/iree-jax.git && cd iree-jax
python -m pip install -e .[test,xla,cpu] -f https://github.com/google/iree/releases
# python setup.py install

