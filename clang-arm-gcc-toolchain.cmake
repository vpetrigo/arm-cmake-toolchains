set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_CMD which)
endif()

execute_process(
        COMMAND ${UTIL_SEARCH_CMD} arm-none-eabi-gcc
        OUTPUT_VARIABLE BINUTILS_PATH
        OUTPUT_STRIP_TRAILING_WHITESPACE
)

get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)
set(triple arm-none-eabi)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_CXX_COMPILER_TARGET ${triple})

set(CMAKE_C_FLAGS_INIT "-B${ARM_TOOLCHAIN_DIR}")
set(CMAKE_CXX_FLAGS_INIT "-B${ARM_TOOLCHAIN_DIR}")
# only for successful compilation of CMake test
set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
# provide clang with ARM GCC toolchain include directory info
include_directories(${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/include)

set(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_DIR}/arm-none-eabi-objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL ${ARM_TOOLCHAIN_DIR}/arm-none-eabi-size CACHE INTERNAL "size tool")

set(CMAKE_FIND_ROOT_PATH ${ARM_TOOLCHAIN_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
