#!/bin/bash

mkdir /opt/iree-host-build && cd /opt/iree-host-build
RELEASE=20220923.275
wget https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree-dist-$RELEASE-linux-x86_64.tar.xz

tar xvf iree-dist-$RELEASE-linux-x86_64.tar.xz
rm iree-dist-$RELEASE-linux-x86_64.tar.xz

source /root/miniconda3/bin/activate
conda init bash
conda activate zoo

pip install https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree_compiler-$RELEASE-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
pip install https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree_runtime-$RELEASE-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
pip install https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree_tools_xla-$RELEASE-py3-none-linux_x86_64.whl
pip install https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree_tools_tflite-$RELEASE-py3-none-linux_x86_64.whl
pip install https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree_tools_tf-$RELEASE-py3-none-linux_x86_64.whl

cd /workspaces
git clone https://github.com/iree-org/iree-jax.git && cd iree-jax
pip install -e .[test,xla,cpu] -f https://github.com/google/iree/releases