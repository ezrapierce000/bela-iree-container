# WIP: Bela IREE Docker container

This project is based on a fork of the [xc-bela-container](https://github.com/rodrigodzf/xc-bela-container) project with added support for IREE projects on Bela. The image comes with IREE host binaries pre-installed, some IREE tools cross-compiled for Bela, a CMake toolchain for building IREE runtime components as well as instructions for benchmarking and profiling IREE programs. Please see the [IREE project](https://iree-org.github.io/iree/) for more details on IREE.

By containerizing the cross-compilation toolchain, Bela code can be written and compiled on any host OS that can run Docker, and is compiled much faster and with more flexibility than in the Bela IDE. The VSCode environment is also set up for running GDB over SSH, allowing you to debug your Bela programs in the editor. This repo is set up to be used with VSCode.


## Quickstart

This project is built with Docker, you can see instructions for installing it [here](https://docs.docker.com/get-docker/).

Once Docker is installed, you can continue the setup using just the command line or using VSCode, both options are shown below.

### Command Line

First, pull the latest docker image:

```shell
docker pull ezrapierce000/xc-bela-iree:latest
```

Then, start and open a shell in the container by running:

```shell
docker run -it ezrapierce000/xc-bela-iree:latest
```

Now, with Bela powered on, change directories, `cd /home/scripts` and run a test benchmark on Bela `./benchmark_test.sh`. This test uploads the iree-benchmark-module tool to the Bela and runs a benchmark on a single multiply between two 4xfloat32 values.


### VSCode

To use this Docker image with VSCode, first clone thi repository:

```shell
git clone --recurse-submodules https://github.com/ezrapierce000/bela-iree-container.git
```

Install the Docker and [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extensions, if you haven't already. 

Open the repo folder in VSCode and run the command `Remote-Containers: Reopen in Container`  or click the popup when prompted, ensure that the environment variables are set accordingly based on the Environment Variables section. This will download the image, install a few extensions and attach the editor to the container.

Once the Docker container has been opened, move to /home/scripts, ensure your Bela is connected and execute the benchmark-test.sh script. This will copy over the iree-benchmark-module tool and runs a benchmark on a single multiply between two 4xf32 values.

## Importing and Compiling models using IREE

As outlined in the IREE [docs](https://iree-org.github.io/iree/#workflow-overview), the general workflow for IREE is as follows:

1. Import your model
2. Select your deployment configuration (Target platform, constraints)
3. Compile your model
4. Run your model

The following sections document a workflow for steps 1-3 for Bela. For running IREE projects in a Bela project please see the [bela-iree-runtime](https://github.com/ezrapierce000/bela-iree-runtime) project.

### Importing your model

You must first import your model into a [MLIR](https://mlir.llvm.org/) dialect which can then be compiled by IREE. This is well supported for TFLite and PyTorch importing is also being worked on with the [Torch-MLIR](https://github.com/llvm/torch-mlir) project.

*TFLite*: IREE provides an importing tool for TFLite models `iree-import-tflite`. This tool comes installed in the container and will import your TFLite model into the [TOSA dialect](https://mlir.llvm.org/docs/Dialects/TOSA/). You can find more in depth docs about using TFLite with IREE [here](https://iree-org.github.io/iree/getting-started/tflite/), but to get started importing a TFLite model to MLIR, run the following command in the Docker container:

```
iree-import-tflite /path/to/tflite/model.tflite -o /path/to/mlir/model/output.mlir
```

Note: You can either load your own *.tflite models into the Docker container using [docker cp](https://docs.docker.com/engine/reference/commandline/cp/) or try building some of the models in /home/models/

*PyTorch*: PyTorch models can also be imported into the TOSA MLIR format using the [Torch-MLIR](https://github.com/llvm/torch-mlir) project.

### Compiling your model for Bela

To compile models using IREE, use the `iree-compile` tool, pre-installed in the container at /opt/iree-host-build/bin/iree-compile.

Use the `--help` flag to see all the different compilation options available.

#### Bela specific flags

TODO: add explanation of important flags

To compile a model from the TOSA dialect (such as models you have imported from TFLite), you can run the following command in the container, pointing to your *.mlir model.

```
/opt/iree-host-build/bin/iree-compile   --iree-input-type=tosa \
                                        --iree-vmvx-enable-microkernels \
                                        --iree-mlir-to-vm-bytecode-module \
                                        --iree-hal-target-backends=dylib-llvm-aot \
                                        --iree-llvm-target-triple=armv7a-pc-linux-eabi \
                                        --iree-llvm-target-float-abi=hard \
                                        --iree-llvm-debug-symbols=false \
                                        --iree-vm-bytecode-module-strip-source-map=true \
                                        --iree-vm-emit-polyglot-zip=false \
                                        /path/to/your/model.mlir \
                                        -o iree_output.vmfb
```


## Performance analysis

Once you have an IREE module compiled, you can benchmark and profile it on Bela. 

### Benchmarking using iree-benchmark-module

[IREE docs](https://github.com/iree-org/iree/blob/main/docs/developers/developing_iree/benchmarking.md)

TODO: replace with basic bash script

To benchmark your IREE module on Bela, you first have to copy over the iree-benchmark-module binary to Bela.

` scp /opt/iree-device-build/tools/iree-benchmark-module root@192.168.6.2: `

Then copy over your *.vmfb file using the same method and SSH to your Bela.

Run `iree-benchmark-module --help` to get a printout of all the required flags.

Example benchmarking command:

`./iree-benchmark-module --device=local-sync:// --module_file=filename.vmfb  --function_input=4xf32=1 2 3 4 --function_input=4xf32= 5 6 7 8 --entry_function=simple_mul `

TODO: Note on how to find entry function name and input sizes.


### Profiling using Tracy
[IREE docs](https://github.com/iree-org/iree/blob/main/docs/developers/developing_iree/profiling_with_tracy.md)

TBD


### Extensions

The extensions installed by default are:

- [clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd) - much better IDE features for C/C++ than the Microsoft extension
- [Native Debug](https://marketplace.visualstudio.com/items?itemName=webfreak.debug) - support for debugging over SSH
- [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - CMake support for building and debugging
- [cmake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake) - syntax highlighting for CMake files

Some others you may want to install locally:

- [DeviceTree](https://marketplace.visualstudio.com/items?itemName=plorefice.devicetree) - syntax highlighting for device tree files
- [PASM Syntax](https://github.com/ebai101/pasm-syntax) - syntax highlighting for PRU assembly
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) - helpful for managing containers in general, also provides syntax highlighting for Dockerfiles

Extensions are stored on a Docker volume, so they will persist through container rebuilds - so you shouldn't need to edit `devcontainer.json` to add extensions, just install them normally. 

### Environment Variables

`.devcontainer/devcontainer.env` contains important environment variables that you should set before building the container:

- **BBB_HOSTNAME** - set this to the IP address of your Bela (could be 192.168.6.2, 192.168.7.2, etc)

You can set any other variables you wish in this file; they will all be sourced when the container starts up.

## Building the Image

You don't usually need to build the image - Docker will pull it from Docker Hub automatically when you open the dev container for the first time. However, if you want to make changes that will persist across container boots, you can rebuild the image yourself. ***Note: These instructions are written for macOS/Linux.***

First, make sure your Bela is connected - you'll need to copy some headers and libraries from it and compile the `libbelafull` static library. Open `scripts/build_settings` and change `BBB_HOSTNAME` to the IP address of your connected Bela.

If the Bela needs to be updated (e.g. if the static libraries haven't been compiled), run these commands:

```shell
Bela/scripts/update_board.sh
scripts/build_libs.sh
```

Ensure that the IREE submodule was properly initiated by running  `git submodule update --init`.

You will only need to do this once, unless you change any of the core library code. Make any changes you wish to the scripts/Dockerfile, then start the build:

```shell
docker build --tag xc-bela-iree:mybuild .
```

Finally, update `.devcontainer/devcontainer.json` to use your custom build:

```json
...
"context": ".",
"image": "xc-bela-iree:mybuild",
"workspaceFolder": "/workspace",
...
```


## Credits

This project is based on a fork of the xc-bela-container [project](https://github.com/rodrigodzf/xc-bela-container).
All credit for the Bela code goes to Bela and Augmented Instruments Ltd. As per the license terms, this project is also licensed under the LGPLv3.

 
