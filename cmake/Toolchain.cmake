
# targets
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv7a)
set(triple arm-linux-gnueabihf)

# compiler settings
set(CMAKE_C_COMPILER /usr/bin/arm-linux-gnueabihf-gcc CACHE INTERNAL "")
set(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++ CACHE INTERNAL "")
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER_TARGET ${triple})
set(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN /usr/lib/llvm-15)
set(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN /usr/lib/llvm-15)
# set(CMAKE_CUSTOM_LINKER /usr/bin/arm-linux-gnueabihf-ld)
add_link_options(-lstdc++ -pthread -lm -ldl -lrt) 
add_compile_options(-g -O3 -g -fPIC -ftree-vectorize -ffast-math -fno-omit-frame-pointer)
add_compile_definitions(_GNU_SOURCE)


set(CMAKE_CROSSCOMPILING ON CACHE BOOL "")
set(CMAKE_C_EXTENSIONS ON)
set(IREE_BUILD_BINDINGS_TFLITE OFF CACHE BOOL "" FORCE)
set(IREE_BUILD_BINDINGS_TFLITE_JAVA OFF CACHE BOOL "" FORCE)
set(IREE_HAL_DRIVER_LOCAL_SYNC ON CACHE BOOL "" FORCE)
set(IREE_ENABLE_THREADING OFF CACHE BOOL "" FORCE)

# misc settings
set(CMAKE_SYSROOT /sysroot)
# set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
