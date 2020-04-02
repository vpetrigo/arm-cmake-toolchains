/* Memory Area specification */
MEMORY {
    VECTORS (rx) : ORIGIN = 0x00000000, LENGTH = 1K
    FCONFIG (rx) : ORIGIN = 0x00000400, LENGTH = 16
    FLASH   (rx) : ORIGIN = 0x00000410, LENGTH = 1047536
    RAM1 (rwx) : ORIGIN = 0x1FFF0000, LENGTH = 64K
    RAM2 (rwx) : ORIGIN = 0x20000000, LENGTH = 192K
}

ENTRY(Reset_Handler)

SECTIONS {
    .isr_vectors : ALIGN(4) {
        __isr_vectors_start__ = .;
        KEEP(*(.isr_vectors));
        __isr_vectors_end__ = .;
    } > VECTORS

    __isr_vectors_size__ = SIZEOF(.isr_vectors);

    .fconfig : ALIGN(4) {
        __fconfig_start__ = .;
        KEEP(*(.fconfig));
        __fconfig_end__ = .;
    } > FCONFIG

    __fconfig_size__ = SIZEOF(.fconfig);
    /* The program code and other data goes into internal flash */
   .text : ALIGN(4) {
        __text_start = .;
        *(.text)                 /* .text sections (code) */
        *(.text*)                /* .text* sections (code) */
        *(.rodata)               /* .rodata sections (constants, strings, etc.) */
        *(.rodata*)              /* .rodata* sections (constants, strings, etc.) */
        *(.glue_7)               /* glue arm to thumb code */
        *(.glue_7t)              /* glue thumb to arm code */
        *(.eh_frame)
        KEEP (*(.init))
        KEEP (*(.fini))
   } > FLASH

   .ARM.extab : {
        *(.ARM.extab .ARM.extab* .gnu.linkonce.armextab.*);
   } > FLASH

   .ARM.extab : {
        *(.ARM.exidx);
   } > FLASH

   __text_end__ = .;
   __text_size__ = SIZEOF(.text);

   .data : AT(__text_end__) ALIGN(4) {
        __data_start__ = .;
        *(.data .data*);
        KEEP(*(.preinit_array));
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array*));
        PROVIDE_HIDDEN (__preinit_array_end = .);
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)));
        KEEP (*(.init_array*));
        PROVIDE_HIDDEN (__init_array_end = .);
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(SORT(.fini_array.*)))
        KEEP (*(.fini_array*));
        PROVIDE_HIDDEN (__fini_array_end = .);
        __data_end__ = .;
   } > RAM1

   __data_size__ = SIZEOF(.data);
   __flash_size = LENGTH(FLASH);
   ASSERT((__text_size__ + __data_size__) <= __flash_size, "Flash memory overflowed with .text and .data sections")

   .bss (NOLOAD) : ALIGN(4) {
        __bss_start__ = .;
        *(.bss .bss*);
        *(COMMON);
        __bss_end__ = .;
   } > RAM1

   __bss_size__ = SIZEOF(.bss);
   ASSERT(__data_size__ + __bss_size__ <= LENGTH(RAM1), "RAM1 memory overflowed with .data and .bss sections")

   end = .;
   __stack_top__ = ORIGIN(RAM1) + LENGTH(RAM1);
}
