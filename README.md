# WIP:bela-iree-benchmark-container

This project is based on a fork of the [xc-bela-container](https://github.com/rodrigodzf/xc-bela-container) project with added support for IREE projects on Bela. The image comes with IREE host binaries pre-installed, some IREE tools cross-compiled for Bela, a CMake toolchain for building IREE runtime components as well as instructions for benchmarking and profiling IREE programs. Please see the [IREE project](https://iree-org.github.io/iree/) for more details on IREE.

By containerizing the cross-compilation toolchain, Bela code can be written and compiled on any host OS that can run Docker, and is compiled much faster and with more flexibility than in the Bela IDE. The VSCode environment is also set up for running GDB over SSH, allowing you to debug your Bela programs in the editor. This repo is set up to be used with VSCode.


### Quickstart

Install [Docker](https://docs.docker.com/get-docker/) and the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extensions, if you haven't already. Clone the repo to your machine:

```shell
git clone --recurse-submodules https://github.com/ezrapierce000/xc-bela-container.git
```

Open the repo folder in VSCode and run the command `Remote-Containers: Reopen in Container`  or click the popup when prompted, ensure that the environment variables are set accordingly based on the Environment Variables section. This will download the image, install a few extensions and attach the editor to the container.

Once the Docker container has been opened, move to /home/scripts, ensure your Bela is connected and execute the benchmark-test.sh script. This will copy over the iree-benchmark-module tool to your Bela along with a compiled test IREE .vmfb file and run a benchmark. The output should be similar to this IMAGE HERE.

## Performance analysis

### Benchmarking using iree-benchmark-module

[IREE docs](https://github.com/iree-org/iree/blob/main/docs/developers/developing_iree/benchmarking.md)

TBD

### Profiling using Tracy
[IREE docs](https://github.com/iree-org/iree/blob/main/docs/developers/developing_iree/profiling_with_tracy.md)

TBD


<!-- The workspace will contain a workspace file called `xc-bela-boostrap.code-workspace`, click on that and choose "Open Workspace." The window will reload and CMake should automatically reconfigure the project. (If it shows an error that says "error: unknown target CPU 'armv7-a'", that's just a bug in the script - run the configuration again and it should work.) -->


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

You will only need to do this once, unless you change any of the core library code. Make any changes you wish to the scripts/Dockerfile, then start the build:

```shell
docker build --tag xc-bela:mybuild .
```

Finally, update `.devcontainer/devcontainer.json` to use your custom build:

```json
...
"context": ".",
"image": "xc-bela:mybuild",
"workspaceFolder": "/workspace",
...
```


## Credits

All credit for the Bela code goes to Bela and Augmented Instruments Ltd. As per the license terms, this project is also licensed under the LGPLv3.

This project is based on a fork of the xc-bela-container [project](https://github.com/rodrigodzf/xc-bela-container). 
