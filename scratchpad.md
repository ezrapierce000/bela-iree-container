# Scratchpad of commands used to build IREE for Bela

See IREE docs [here](https://github.com/iree-org/iree/blob/main/docs/developers/get_started/cmake_options_and_variables.md) for an overview of CMake flags.

## Host builds

	cmake  -B ../iree-build/ -S . \
	    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
	    -DIREE_ENABLE_ASSERTIONS=ON \
	    -DCMAKE_C_COMPILER=clang \
	    -DCMAKE_CXX_COMPILER=clang++ \
	    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
	    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache

## Device builds

cmake -B build/ -S . \
	-DCMAKE_TOOLCHAIN_FILE="/home/cmake/Toolchain.cmake" \
	-DIREE_HOST_BINARY_ROOT="/opt/iree-host-build" \
	-DIREE_BUILD_COMPILER=OFF \
	-DIREE_BUILD_TESTS=OFF \
	-DIREE_BUILD_SAMPLES=ON \
	-DIREE_DEVICE_SIZE=uint32_t \
	-DIREE_TARGET_BACKEND_DEFAULTS=OFF \
	-DIREE_TARGET_BACKEND_DYLIB_LLVM_AOT=ON \
	-DIREE_TARGET_BACKEND_VMVX=ON \
	-DIREE_HAL_DRIVER_DEFAULTS=OFF \
	-DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
	-DIREE_HAL_EXECUTABLE_LOADER_EMBEDDED_ELF=ON

Add -DIREE_BUILD_TRACY=ON for profiling support.

## Importing models

### TFLite
From these IREE [docs](https://iree-org.github.io/iree/getting-started/tflite/)

iree-import-tflite /path/to/tflite/model.tflite -o /path/to/mlir/model/output.mlir


## Compiling models

### Compiler flags

More information about iree-compile flags can be seen from the help menu (iree-compile --help). 

--iree-input-type=<tosa|mhlo|...>
--iree-target-backends=<cpu|vmvx...>


Some flags being used with recent microkernel addition
--iree-vmvx-enable-microkernels
--mlir-print-ir-before=iree-vmvx-lower-linalg-microkernels --mlir-print-ir-after=iree-vmvx-lower-linalg-microkernels

iree-compile \
    --iree-input-type=tosa \
    --iree-hal-target-backends=cpu \
    ${IMPORT_PATH} \
    -o ${MODULE_PATH}

## Benchmarking modules

To benchmark a model using the IREE benchmaring tool you must pass in the path to the module, the device to benchmark with (in the Bela case it is local-sync://), the function name and the function inputs. Below is an example command for benchmarking a multiply between two 4xf32 vectors.

./iree-benchmark-module --module_file=simple_embedding_test_bytecode_module_dylib_arm_32.vmfb --device=local-sync:// --function_input=4xf32=1 2 3 4 --function_input=4xf32= 5 6 7 8 --entry_function=simple_mul

## Profiling models

...

TRACY_NO_EXIT=1 IREE_PRESERVE_DYLIB_TEMP_FILES=1 ./iree-benchmark-module --module_file=simple_embedding_test_bytecode_module_dylib_arm_32.vmfb --device=local-sync:// --function_input=4xf32=1 2 3 4 --function_input=4xf32= 5 6 7 8 --entry_function=simple_mul

