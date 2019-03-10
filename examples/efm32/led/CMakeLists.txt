cmake_minimum_required(VERSION 3.5)
project(efm32gg_led)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_C_COMPILER_TARGET thumbv7m-unknown-none-eabi)
set(CMAKE_CXX_COMPILER_TARGET thumbv7m-unknown-none-eabi)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CPU_FLAGS "-mthumb -mcpu=cortex-m3 -march=armv7-m -mfloat-abi=soft")
set(COMPILER_FLAGS "-ffreestanding -ffunction-sections -fdata-sections -fsigned-char -fmessage-length=0 -fshort-enums")
set(SIL_GECKO_SDK "${CMAKE_CURRENT_LIST_DIR}/../Gecko_SDK")
set(PLATFORM_PATH "platform/Device/SiliconLabs/EFM32GG")
set(LINKER_FILE "${CMAKE_CURRENT_LIST_DIR}/efm32gg.ld")

add_definitions(${CPU_FLAGS} ${COMPILER_FLAGS})
add_definitions(-DEFM32GG990F1024)

include(../../../utils.cmake)
include(../gecko.cmake)

emlib_add(${SIL_GECKO_SDK})
emlib_inc_dir(${SIL_GECKO_SDK})
device_inc_dir(${SIL_GECKO_SDK} "EFM32GG")
device_src_dir(${SIL_GECKO_SDK} "EFM32GG")
gecko_cmsis_dir(${SIL_GECKO_SDK})

if("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
    string(APPEND CMAKE_EXE_LINKER_FLAGS " -nostdlib")
    string(APPEND CMAKE_EXE_LINKER_FLAGS " -L${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/lib/thumb/v7-m/nofp")
    string(APPEND CMAKE_EXE_LINKER_FLAGS " -L${ARM_TOOLCHAIN_DIR}/../lib/gcc/arm-none-eabi/8.2.1/thumb/v7-m/nofp")
    string(APPEND CMAKE_EXE_LINKER_FLAGS " -lgcc -lnosys -lc -lg")
elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
    string(REGEX MATCH ".*\.specs.*" has_specs "${CMAKE_EXE_LINKER_FLAGS}")
    
    if(NOT has_specs)
        string(APPEND CMAKE_EXE_LINKER_FLAGS " --specs=nosys.specs")
    endif()
endif()

string(APPEND CMAKE_EXE_LINKER_FLAGS " ${CPU_FLAGS} -Wl,-T ${LINKER_FILE}")
# string(APPEND CMAKE_EXE_LINKER_FLAGS " -Wl,--gc-sections")


add_library(emlib ${emlib_src})
target_include_directories(emlib PUBLIC ${emlib_inc} ${device_inc} ${cmsis_inc})

add_library(startup ${device_src}/GCC/startup_efm32gg.c)
add_library(system ${device_src}/system_efm32gg.c)
target_include_directories(system PUBLIC ${emlib_inc} ${device_inc} ${cmsis_inc})

if ("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
    list(APPEND efm32_test_obj ${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/lib/thumb/v7-m/nofp/crt0.o)
    list(APPEND efm32_test_obj ${ARM_TOOLCHAIN_DIR}/../lib/gcc/arm-none-eabi/8.2.1/thumb/v7-m/nofp/crti.o)
endif()

 add_executable(efm32_test main.c ${efm32_test_obj})
target_link_libraries(efm32_test emlib startup system)

firmware_size(efm32_test)
generate_object(efm32_test .bin binary)

if ("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
    generate_object(efm32_test .hex ihex)
endif()
