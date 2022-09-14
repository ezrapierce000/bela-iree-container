#!/bin/bash

wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
chmod +x ./Anaconda3-2022.05-Linux-x86_64.sh

CONDA_SUBDIR=osx-64 conda create -n zoo-tf -c conda-forge python pip fire tensorflow
conda activate zoo-tf
conda config --env --set subdir osx-64
CONDA_SUBDIR=osx-64 conda create -n zoo -c conda-forge python pip fire
conda activate zoo
conda config --env --set subdir osx-64
