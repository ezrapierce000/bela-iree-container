#!/bin/bash -e

apt-get update
apt-get install -y wget gpg apt-utils curl #apt-transport-https ca-certificates

# Add llvm and debian repos
echo "deb http://http.us.debian.org/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list.d/bullseye.list

# Installing CMake 3.23
wget https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2-linux-x86_64.sh
chmod +x cmake-3.23.2-linux-x86_64.sh
yes | ./cmake-3.23.2-linux-x86_64.sh
ln -s /cmake-3.23.2-linux-x86_64/bin/cmake /usr/bin/cmake
cmake --version

apt-get update

apt-get install --no-install-recommends -y \
	ninja-build \
	coreutils \
	linux-libc-dev-armhf-cross \
	g++-10-arm-linux-gnueabihf \
	gcc-10-arm-linux-gnueabihf \
	gcc-arm-linux-gnueabihf \
	g++-arm-linux-gnueabihf \
	binutils-arm-linux-gnueabihf \
	debootstrap \
	build-essential \
	rsync \
	ssh \
	git \
	gdb \
	vim \
	ccache \
	lsb-release \
	wget \
	software-properties-common \
	libcapstone-dev \
	libtbb-dev \
	libzstd-dev \
	pkg-config \
	linux-perf \
	kmod \
	lzop \
	cpio \
	bc \
	fakeroot \
	man-db \
	gettext \
	libmpc-dev \
	u-boot-tools \
	libssl-dev:amd64 \
	qemu \
	qemu-user-static \
	dh-autoreconf \
	sshpass \
	g++-aarch64-linux-gnu \
	binutils-aarch64-linux-gnu \
	gcc-aarch64-linux-gnu

bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
rm -rf /var/lib/apt/lists/*

echo "Finishing up..."
