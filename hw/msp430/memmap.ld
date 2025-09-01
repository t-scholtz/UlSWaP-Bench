/* OpenMSP430 picolibc linker script
 * 48KB PMEM, 10KB DMEM configuration
 * 16-bit addressing only
 * Memory layout: Peripherals -> DMEM -> [blank area] -> PMEM -> Vectors
 */

/* Memory configuration */
__per_size    = 0x0200;    /* 512 bytes for peripherals */
__dmem_base   = __per_size; /* Data memory starts after peripherals */
__dmem_size   = 0x2800;    /* 10KB data memory */
__pmem_full_size   = 0xc000;    /* 48KB program memory */
__rst_space   = 0x0010;
__pmem_size   = __pmem_full_size - __rst_space - 0x0020; /* Pmem also stores the vector table plus restart handler which we need to account for */
__rst_base    = 0x10000 - __pmem_full_size; /* Reset jump area at start of PMEM */
__pmem_base   = 0x10000 - __pmem_size;    /* PMEM extends down from vector table */

PROVIDE (__stack = __dmem_base + __dmem_size);

PROVIDE(_Exit = _exit);
PROVIDE(__exit = _exit);

INCLUDE picolibc.ld

/* Memory map */
MEMORY {
  PERIPHERALS : ORIGIN = 0x0000, LENGTH = __per_size
  
  DMEM        : ORIGIN = __dmem_base, LENGTH = __dmem_size
  
  RSTJMP      : ORIGIN = __rst_base, LENGTH = __rst_space
  
  PMEM        : ORIGIN = __pmem_base, LENGTH = __pmem_size
  
  VECT0       : ORIGIN = 0xFFE0, LENGTH = 0x0002
  VECT1       : ORIGIN = 0xFFE2, LENGTH = 0x0002
  VECT2       : ORIGIN = 0xFFE4, LENGTH = 0x0002
  VECT3       : ORIGIN = 0xFFE6, LENGTH = 0x0002
  VECT4       : ORIGIN = 0xFFE8, LENGTH = 0x0002
  VECT5       : ORIGIN = 0xFFEA, LENGTH = 0x0002
  VECT6       : ORIGIN = 0xFFEC, LENGTH = 0x0002
  VECT7       : ORIGIN = 0xFFEE, LENGTH = 0x0002
  VECT8       : ORIGIN = 0xFFF0, LENGTH = 0x0002
  VECT9       : ORIGIN = 0xFFF2, LENGTH = 0x0002
  VECT10      : ORIGIN = 0xFFF4, LENGTH = 0x0002
  VECT11      : ORIGIN = 0xFFF6, LENGTH = 0x0002
  VECT12      : ORIGIN = 0xFFF8, LENGTH = 0x0002
  VECT13      : ORIGIN = 0xFFFA, LENGTH = 0x0002
  VECT14      : ORIGIN = 0xFFFC, LENGTH = 0x0002
  RESETVEC    : ORIGIN = 0xFFFE, LENGTH = 0x0002
}

SECTIONS {
  /* Reset jump section (executed first on reset) */
  __rstjmp : {
    KEEP(*(.rstjmp))
  } > RSTJMP

  /* Initialization code section */
  .init : {
    KEEP(*(.init))
    KEEP(*(.init.*))
    . = ALIGN(2);
  } > PMEM

  /* Program sections */
  .text : {
      /* Ensure _start comes first */
      KEEP(*(.text._start))
      /* Ensure _exit is included */
      KEEP(*(.text._exit))
      *(.text)
      *(.text.*)
      . = ALIGN(2);
      __text_end = .;
  } > PMEM

  /* Read-only data */
  .rodata : {
    *(.rodata)
    *(.rodata.*)
    . = ALIGN(2);
  } > PMEM

  /* BSS section (uninitialized variables) */
  .bss : {
    __bss_start = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    . = ALIGN(2);
    __bss_end = .;
  } > DMEM


  /* Interrupt vectors */
  __interrupt_vector_0  : { KEEP(*(__interrupt_vector_0))  } > VECT0
  __interrupt_vector_1  : { KEEP(*(__interrupt_vector_1))  } > VECT1
  __interrupt_vector_2  : { KEEP(*(__interrupt_vector_2))  } > VECT2
  __interrupt_vector_3  : { KEEP(*(__interrupt_vector_3))  } > VECT3
  __interrupt_vector_4  : { KEEP(*(__interrupt_vector_4))  } > VECT4
  __interrupt_vector_5  : { KEEP(*(__interrupt_vector_5))  } > VECT5
  __interrupt_vector_6  : { KEEP(*(__interrupt_vector_6))  } > VECT6
  __interrupt_vector_7  : { KEEP(*(__interrupt_vector_7))  } > VECT7
  __interrupt_vector_8  : { KEEP(*(__interrupt_vector_8))  } > VECT8
  __interrupt_vector_9  : { KEEP(*(__interrupt_vector_9))  } > VECT9
  __interrupt_vector_10 : { KEEP(*(__interrupt_vector_10)) } > VECT10
  __interrupt_vector_11 : { KEEP(*(__interrupt_vector_11)) } > VECT11
  __interrupt_vector_12 : { KEEP(*(__interrupt_vector_12)) } > VECT12
  __interrupt_vector_13 : { KEEP(*(__interrupt_vector_13)) } > VECT13
  __interrupt_vector_14 : { 
    KEEP(*(__interrupt_vector_14)) 
    KEEP(*(__interrupt_vector_nmi)) 
  } > VECT14

  /* Reset vector */
  __reset_vector : {
    KEEP(*(__interrupt_vector_reset))
    KEEP(*(.resetvec))
  } > RESETVEC

    /* Provide load addresses for data initialization */
  __data_load_start = LOADADDR(.data);
  __data_load_end = __data_load_start + SIZEOF(.data);

}