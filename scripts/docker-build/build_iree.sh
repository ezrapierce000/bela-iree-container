#!/bin/bash

mkdir /opt/iree-host-build && cd /opt/iree-host-build
RELEASE=2022912.264
wget https://github.com/iree-org/iree/releases/download/candidate-$RELEASE/iree-dist-$RELEASE-linux-x86_64.tar.xz

tar xvf iree-dist-$RELEASE-linux-x86_64.tar.xz
rm iree-dist-$RELEASE-linux-x86_64.tar.xz

cd /home/iree/

cmake -B /opt/iree-device-build/ -S . \
        -DCMAKE_TOOLCHAIN_FILE="/home/cmake/Toolchain.cmake" \
        -DIREE_HOST_BINARY_ROOT="/opt/iree-host-build" \
        -DIREE_BUILD_COMPILER=OFF \
        -DIREE_BUILD_TESTS=OFF \
        -DIREE_BUILD_SAMPLES=OFF \
        -DIREE_DEVICE_SIZE=uint32_t \
        -DIREE_TARGET_BACKEND_DEFAULTS=OFF \
        -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
        -DIREE_TARGET_BACKEND_VMVX=ON \
        -DIREE_HAL_DRIVER_DEFAULTS=OFF \
        -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
        -DIREE_HAL_EXECUTABLE_LOADER_EMBEDDED_ELF=ON

cmake --build /opt/iree-device-build/

