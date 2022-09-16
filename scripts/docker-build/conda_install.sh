#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
chmod +x ./Miniconda3-py39_4.12.0-Linux-x86_64.sh
./Miniconda3-py39_4.12.0-Linux-x86_64.sh -b

source /root/miniconda3/bin/activate

yes | CONDA_SUBDIR=linux-64 conda create -n zoo-tf -c conda-forge python pip fire
conda activate zoo-tf
conda config --env --set subdir linux-64
pip install tensorflow==2.10 tensorflow-probability onnx-tf

yes | CONDA_SUBDIR=linux-64 conda create -n zoo -c conda-forge python pip fire jax
conda activate zoo
conda config --env --set subdir linux-64

python -m pip install https://github.com/llvm/torch-mlir/releases/download/snapshot-20220916.598/torch-1.13.0.dev20220916+cpu-cp310-cp310-linux_x86_64.whl
python -m pip install https://github.com/llvm/torch-mlir/releases/download/snapshot-20220916.598/torch_mlir-20220916.598-cp310-cp310-linux_x86_64.whl

cd /opt
git clone https://github.com/iree-org/iree-jax.git && cd iree-jax
python -m pip install -e .[test,xla,cpu] -f https://github.com/google/iree/releases

