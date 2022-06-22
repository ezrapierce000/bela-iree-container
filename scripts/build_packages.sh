#!/bin/bash -e

apt-get update
apt-get install -y wget gpg apt-utils #apt-transport-https ca-certificates

# Add llvm and debian repos
echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye main" >> /etc/apt/sources.list.d/llvm.list
echo "deb http://http.us.debian.org/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list.d/bullseye.list
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

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
	cmake \
	git \
	gdb \


rm -rf /var/lib/apt/lists/*




echo "Finishing up..."
