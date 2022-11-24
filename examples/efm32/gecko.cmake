function(emlib_add gecko_sdk_path)
    file(GLOB emlib_src ${gecko_sdk_path}/platform/emlib/src/*.c)
    # em_int.c is deprecated in the 5.1.2 SDK so clean it up
    string(REPLACE "em_int.c" "" emlib_src "${emlib_src}")
    set(emlib_src ${emlib_src} PARENT_SCOPE)
endfunction()

function(emlib_inc_dir gecko_sdk_path)
    set(emlib_inc ${gecko_sdk_path}/platform/emlib/inc ${gecko_sdk_path}/platform/common/inc PARENT_SCOPE)
endfunction()

function(device_inc_dir gecko_sdk_path dev_name)
    set(device_inc ${gecko_sdk_path}/platform/Device/SiliconLabs/${dev_name}/Include PARENT_SCOPE)
endfunction()

function(device_src_dir gecko_sdk_path dev_name)
    set(device_src ${gecko_sdk_path}/platform/Device/SiliconLabs/${dev_name}/Source PARENT_SCOPE)
endfunction()

function(gecko_cmsis_dir gecko_sdk_path)
    set(cmsis_inc ${gecko_sdk_path}/platform/CMSIS/Core/Include PARENT_SCOPE)
endfunction()
