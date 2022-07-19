#!/bin/bash

mkdir /opt/iree-host-build && cd /opt/iree-host-build

wget https://github.com/iree-org/iree/releases/download/candidate-20220717.207/iree-dist-20220717.207-linux-x86_64.tar.xz

tar xvf iree-dist-20220717.207-linux-x86_64.tar.xz
rm iree-dist-20220717.207-linux-x86_64.tar.xz


