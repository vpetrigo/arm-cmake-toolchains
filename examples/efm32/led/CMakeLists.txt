cmake_minimum_required(VERSION 3.5)
project(efm32gg_led ASM C)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CPU_FLAGS "-mthumb -mcpu=cortex-m3")
set(COMPILER_FLAGS "-ffreestanding -ffunction-sections -fdata-sections -fsigned-char -fmessage-length=0 -fshort-enums ")
set(SIL_GECKO_SDK "${CMAKE_CURRENT_LIST_DIR}/../Gecko_SDK")
set(PLATFORM_PATH "platform/Device/SiliconLabs/EFM32GG")
set(LINKER_FILE "${SIL_GECKO_SDK}/${PLATFORM_PATH}/Source/GCC/efm32gg.ld")

add_definitions(${CPU_FLAGS} ${COMPILER_FLAGS})
add_definitions(-DEFM32GG990F1024)

include(../../../utils.cmake)
include(../gecko.cmake)

emlib_add(${SIL_GECKO_SDK})
emlib_inc_dir(${SIL_GECKO_SDK})
device_inc_dir(${SIL_GECKO_SDK} "EFM32GG")
device_src_dir(${SIL_GECKO_SDK} "EFM32GG")
gecko_cmsis_dir(${SIL_GECKO_SDK})

set(dev_system_src ${device_src}/system_efm32gg.c)

if ("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
    SET(CMAKE_EXE_LINKER_FLAGS "-Wl,-T ${LINKER_FILE} --specs=nosys.specs")
elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
    message("Clang Bang")
endif()

list(FILTER emlib_src EXCLUDE REGEX ".*em_int.c")

add_library(emlib ${emlib_src})
target_include_directories(emlib PUBLIC ${emlib_inc} ${device_inc} ${cmsis_inc})

add_executable(efm32_test main.c ${device_src}/GCC/startup_efm32gg.S ${dev_system_src})
target_link_libraries(efm32_test emlib)

firmware_size(efm32_test)
generate_object(efm32_test .bin binary)