
# targets
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(triple aarch64-linux-gnu)

# compiler settings
set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc CACHE STRING "")
set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++ CACHE STRING "")
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER_TARGET ${triple})
set(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN /usr/lib/llvm-15)
set(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN /usr/lib/llvm-15)
add_link_options(-lstdc++ -pthread -lm -ldl -lrt)
add_compile_options(-g -O3 -g -fPIC -ftree-vectorize -ffast-math -fno-omit-frame-pointer)
add_compile_definitions(_GNU_SOURCE)

set(CMAKE_CROSSCOMPILING ON CACHE BOOL "")
set(CMAKE_C_EXTENSIONS ON)
set(IREE_BUILD_BINDINGS_TFLITE OFF CACHE BOOL "" FORCE)
set(IREE_BUILD_BINDINGS_TFLITE_JAVA OFF CACHE BOOL "" FORCE)
set(IREE_HAL_DRIVER_LOCAL_SYNC ON CACHE BOOL "" FORCE)
set(IREE_ENABLE_THREADING ON CACHE BOOL "" FORCE)

# misc settings
set(CMAKE_SYSROOT /sysroot)
# set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
