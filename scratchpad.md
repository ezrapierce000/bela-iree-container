# Scratchpad of commands used to build IREE for Bela


## Host builds


## Device builds

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

iree-benchmark-module...


