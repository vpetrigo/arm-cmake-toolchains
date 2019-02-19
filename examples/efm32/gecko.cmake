function(emlib_add gecko_sdk_path)
    file(GLOB emlib_src ${gecko_sdk_path}/platform/emlib/src/*.c)
    set(emlib_src ${emlib_src} PARENT_SCOPE)
endfunction()

function(emlib_inc_dir gecko_sdk_path)
    set(emlib_inc ${gecko_sdk_path}/platform/emlib/inc PARENT_SCOPE)
endfunction()

function(device_inc_dir gecko_sdk_path dev_name)
    set(device_inc ${gecko_sdk_path}/platform/Device/SiliconLabs/${dev_name}/Include PARENT_SCOPE)
endfunction()

function(device_src_dir gecko_sdk_path dev_name)
    set(device_src ${gecko_sdk_path}/platform/Device/SiliconLabs/${dev_name}/Source PARENT_SCOPE)
endfunction()

function(gecko_cmsis_dir gecko_sdk_path)
    set(cmsis_inc ${gecko_sdk_path}/platform/CMSIS/Include PARENT_SCOPE)
endfunction()