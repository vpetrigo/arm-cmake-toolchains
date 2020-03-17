# Retrieve ARM GCC sysroot for further usage with Clang
# Pass @compiler and @cpu_flags and the macro set up
# ARM_GCC_SYSROOT variable with proper sysroot string
# Example:
# ```cmake
# set(ARM_GCC_C_COMPILER arm-none-eabi-gcc)
# set(CPU_FLAGS -mthumb -mcpu=cortex-m3)
# clang_get_arm_gcc_sysroot(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
# message("ARM GCC sysroot: ${ARM_GCC_SYSROOT}")
# ```
macro(clang_utils_get_arm_gcc_sysroot compiler cpu_flags)
    execute_process(COMMAND ${compiler}
        ${cpu_flags} -print-sysroot OUTPUT_VARIABLE ARM_GCC_SYSROOT
        OUTPUT_STRIP_TRAILING_WHITESPACE)
endmacro()

# Retrieve ARM GCC multilib directory for further usage with Clang
# Pass @compiler and @cpu_flags and the macro set up
# ARM_GCC_MULTIDIR variable with proper multilib string
# Example:
# ```cmake
# set(ARM_GCC_C_COMPILER arm-none-eabi-gcc)
# set(CPU_FLAGS -mthumb -mcpu=cortex-m3)
# clang_utils_get_arm_gcc_multilib_dir(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
# message("ARM GCC multilib: ${ARM_GCC_MULTIDIR}")
# ```
macro(clang_utils_get_arm_gcc_multilib_dir compiler cpu_flags)
    execute_process(COMMAND ${compiler} ${cpu_flags} -print-multi-directory
        OUTPUT_VARIABLE ARM_GCC_MULTIDIR
        OUTPUT_STRIP_TRAILING_WHITESPACE)
endmacro()

# Retrieve ARM GCC libgcc directory for further usage with Clang
# Pass @compiler and @cpu_flags and the macro set up
# ARM_GCC_LIBGCC variable with proper libgcc path string
# Example:
# ```cmake
# set(ARM_GCC_C_COMPILER arm-none-eabi-gcc)
# set(CPU_FLAGS -mthumb -mcpu=cortex-m3)
# clang_utils_get_arm_gcc_lib_dir(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
# message("ARM GCC multilib: ${ARM_GCC_LIBGCC}")
# ```
macro(clang_utils_get_arm_gcc_lib_dir compiler cpu_flags)
    execute_process(COMMAND ${compiler} ${cpu_flags} -print-libgcc-file-name
        OUTPUT_VARIABLE ARM_GCC_LIBGCC
        OUTPUT_STRIP_TRAILING_WHITESPACE)
endmacro()

# Set ARM GCC CRT objects variables for further usage with Clang
# Pass @sysroot, @multilib_dir and @libgcc_dir for the macro to set up
# CRT0_OBJ and CRT_OBJ variables with proper object files
# Example:
# ```cmake
# set(ARM_GCC_C_COMPILER arm-none-eabi-gcc)
# set(CPU_FLAGS -mthumb -mcpu=cortex-m3)
# clang_utils_get_arm_gcc_lib_dir(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
# message("ARM GCC multilib: ${ARM_GCC_LIBGCC}")
# ```
macro(clang_utils_get_arm_gcc_crt sysroot multilib_dir libgcc_dir)
    set(CRT0_OBJ ${sysroot}/lib/${multilib_dir}/crt0.o)
    set(CRT_OBJ ${libgcc_dir}/crti.o
        ${libgcc_dir}/crtn.o
        ${libgcc_dir}/crtfastmath.o
        ${libgcc_dir}/crtbegin.o
        ${libgcc_dir}/crtend.o)
endmacro()
