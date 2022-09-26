#!/bin/bash
RELEASE=20220925.277
mkdir /opt/iree-host-build && cd /opt/iree-host-build
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


cd /workspaces/bela-iree-container/iree
cmake -S . -B /opt/iree-bela-build  -DCMAKE_TOOLCHAIN_FILE=/home/cmake/Toolchain.cmake \
                                    -DIREE_HOST_BINARY_ROOT=/opt/iree-host-build \
                                    -DIREE_BUILD_COMPILER=OFF \
                                    -DIREE_BUILD_TESTS=OFF \
                                    -DIREE_BUILD_SAMPLES=ON \
                                    -DIREE_DEVICE_SIZE=uint32_t \
                                    -DIREE_TARGET_BACKEND_DEFAULTS=OFF \
                                    -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
                                    -DIREE_TARGET_BACKEND_VMVX=ON \
                                    -DIREE_HAL_DRIVER_DEFAULTS=OFF \
                                    -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
                                    -DIREE_HAL_EXECUTABLE_LOADER_EMBEDDED_ELF=ON

cmake -S . -B /opt/iree-ai-build  -DCMAKE_TOOLCHAIN_FILE=/home/cmake/ToolchainAI.cmake \
                                    -DIREE_HOST_BINARY_ROOT=/opt/iree-host-build \
                                    -DIREE_BUILD_COMPILER=OFF \
                                    -DIREE_BUILD_TESTS=OFF \
                                    -DIREE_BUILD_SAMPLES=ON \
                                    -DIREE_TARGET_BACKEND_DEFAULTS=OFF \
                                    -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
                                    -DIREE_TARGET_BACKEND_VMVX=ON \
                                    -DIREE_HAL_DRIVER_DEFAULTS=OFF \
                                    -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
                                    -DIREE_HAL_EXECUTABLE_LOADER_EMBEDDED_ELF=ON

cmake --build /opt/iree-bela-build/tools --target all -j8 && cmake --build /opt/iree-ai-build/tools --target all -j8
