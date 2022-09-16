#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
chmod +x ./Miniconda3-py39_4.12.0-Linux-x86_64.sh
./Miniconda3-py39_4.12.0-Linux-x86_64.sh -b

CONDA_SUBDIR=osx-64 conda create -n zoo-tf -c conda-forge python pip fire tensorflow
conda activate zoo-tf
conda config --env --set subdir osx-64
CONDA_SUBDIR=osx-64 conda create -n zoo -c conda-forge python pip fire
conda activate zoo
conda config --env --set subdir osx-64
