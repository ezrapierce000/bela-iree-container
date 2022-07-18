#!/bin/bash -e

apt-get update
apt-get install -y wget gpg apt-utils #apt-transport-https ca-certificates

# Add llvm and debian repos
echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye main" >> /etc/apt/sources.list.d/llvm.list
echo "deb http://http.us.debian.org/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list.d/bullseye.list
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

# Installing CMake 3.24
wget https://github.com/Kitware/CMake/releases/download/v3.24.0-rc3/cmake-3.24.0-rc3-linux-x86_64.sh
chmod +x cmake-3.24.0-rc3-linux-x86_64.sh
yes | ./cmake-3.24.0-rc3-linux-x86_64.sh
ln -s /cmake-3.24.0-rc3-linux-x86_64/bin/cmake /usr/bin/cmake
cmake --version

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

echo "Finishing up..."
