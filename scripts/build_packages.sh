#!/bin/bash -e

apt-get update
apt-get install -y wget gpg apt-utils #apt-transport-https ca-certificates

# Add llvm and debian repos
echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye main" >> /etc/apt/sources.list.d/llvm.list
echo "deb http://http.us.debian.org/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list.d/bullseye.list
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

wget https://github.com/Kitware/CMake/releases/download/v3.24.0-rc3/cmake-3.24.0-rc3-linux-x86_64.sh
chmod +x cmake-3.24.0-rc3-linux-x86_64.sh
yes | ./cmake-3.24.0-rc3-linux-x86_64.sh
cd ./cmake-3.24.0-rc3-linux-x86_64/bin
pwd
ln -s /cmake-3.24.0-rc3-linux-x86_64/bin/cmake /usr/bin/cmake
cmake --version

# add conan repo
# wget -qO - https://releases.jfrog.io/artifactory/api/gpg/key/public | apt-key add -
# echo "deb https://releases.jfrog.io/artifactory/artifactory-debs buster main" >>  /etc/apt/sources.list.d/conan.list
wget https://github.com/conan-io/conan/releases/latest/download/conan-ubuntu-64.deb
dpkg -i conan-ubuntu-64.deb

apt-get update

apt-get install --no-install-recommends -y \
	clang \
	clangd \
	ninja-build \
	coreutils \
	linux-libc-dev-armhf-cross \
	g++-10-arm-linux-gnueabihf \
	gcc-10-arm-linux-gnueabihf \
	gcc-arm-linux-gnueabihf \
	g++-arm-linux-gnueabihf \
	binutils-arm-linux-gnueabihf \
	build-essential \
	rsync \
	ssh \
	git \
	gdb \
	ccache


rm -rf /var/lib/apt/lists/*

cd /iree

cmake -GNinja -B ../iree-build/ -S . \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DIREE_ENABLE_ASSERTIONS=ON \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DIREE_ENABLE_LLD=OFF


echo "Finishing up..."
