#!/bin/bash


if [ ! -f ${2} ]; then
	echo "file does not exist."
	exit
fi

OPTIONS="--iree-input-type=tosa  --iree-mlir-to-vm-bytecode-module --iree-vm-emit-polyglot-zip=false"
OPTIMIZATIONS="--iree-opt-const-eval --iree-vmvx-enable-microkernels --iree-opt-const-expr-hoisting --iree-opt-numeric-precision-reduction --iree-vm-bytecode-module-optimize"

if [ ${1} == "bbb" ]; then
	echo "bela!"
	HW_OPTIONS="--iree-hal-target-backends=dylib-llvm-aot --iree-llvm-target-triple=armv7a-pc-linux-eabi --iree-llvm-target-float-abi=hard"
	MORE="--iree-llvm-target-cpu-features=armv7-a"
elif [ ${1} == "bbai64" ]; then
	echo "bbai64"
	HW_OPTIONS="--iree-hal-target-backends=dylib-llvm-aot --iree-llvm-target-triple=armv7a-pc-linux-eabi --iree-llvm-target-float-abi=hard"
elif [ ${1} == "x86" ]; then
	echo "host!"
	HW_OPTIONS="--iree-hal-target-backends=dylib-llvm-aot" 
else
	echo "platform not supported"
fi


	/home/ezra/.local/bin/iree-compile $OPTIONS $HW_OPTIONS ${2} -o ${3}

echo $CMD
