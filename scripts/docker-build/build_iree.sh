#!/bin/bash

mkdir /opt/iree-host-build && cd /opt/iree-host-build
RELEASE=20220912.264
wget https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree-dist-$RELEASE-linux-x86_64.tar.xz

tar xvf iree-dist-$RELEASE-linux-x86_64.tar.xz
rm iree-dist-$RELEASE-linux-x86_64.tar.xz


