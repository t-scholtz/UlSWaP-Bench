/*  MSP430F1611 picolibc linker script
 *  48KB Flash, 10KB RAM, Basic MSP430 (not MSP430X)
 */

/* MSP430F1611 Memory Layout:
 * Flash: 0x4000-0xFFDF (48KB - 32 bytes for vectors)
 * RAM:   0x1100-0x38FF (10KB) 
 * Vectors: 0xFFE0-0xFFFF (32 bytes, 16 vectors)
 */

__flash       = 0x00004000;
__flash_size  = 0x0000BFCF;   /* 48KB up to 0xFFCF (before MMIO) */
__ram         = 0x00001100;   /* MSP430F1611 RAM starts at 0x1100 */
__ram_size    = 0x00002800;   /* 10KB RAM (0x2800 bytes) */
__stack_size  = 0x400;        /* 1KB stack */

__mmio_base   = 0x0000FFD0;
__mmio_size   = 0x0000000c;

INCLUDE /home/tjscholtz/ti/msp430-gcc/include/msp430f1611_symbols.ld

/*  MSP430F1611 has 16 interrupt vectors (not 55 like MSP430FR5994)
 *  Vector table: 0xFFE0-0xFFFF
 */

MEMORY{
  /* Main memory regions */
  FLASH            : ORIGIN = 0x4000, LENGTH = 0xBFD0  /* Continuous flash up to MMIO */
  RAM              : ORIGIN = 0x1100, LENGTH = 0x2800
  
  /* MMIO region - reserve 2 words at 0xFFD0 (before vectors) */
  MMIO             : ORIGIN = 0xFFD0, LENGTH = 0x00012
  
  /* MSP430F1611 Interrupt vectors (16 vectors, not 55) */
  VECT0            : ORIGIN = 0xFFE0, LENGTH = 0x0002  /* Basic Timer */
  VECT1            : ORIGIN = 0xFFE2, LENGTH = 0x0002  /* Port 2 */
  VECT2            : ORIGIN = 0xFFE4, LENGTH = 0x0002  /* USART1 TX */
  VECT3            : ORIGIN = 0xFFE6, LENGTH = 0x0002  /* USART1 RX */
  VECT4            : ORIGIN = 0xFFE8, LENGTH = 0x0002  /* Port 1 */
  VECT5            : ORIGIN = 0xFFEA, LENGTH = 0x0002  /* Timer A CCR1 */
  VECT6            : ORIGIN = 0xFFEC, LENGTH = 0x0002  /* Timer A CCR0 */
  VECT7            : ORIGIN = 0xFFEE, LENGTH = 0x0002  /* ADC12 */
  VECT8            : ORIGIN = 0xFFF0, LENGTH = 0x0002  /* USART0 TX */
  VECT9            : ORIGIN = 0xFFF2, LENGTH = 0x0002  /* USART0 RX */
  VECT10           : ORIGIN = 0xFFF4, LENGTH = 0x0002  /* WDT */
  VECT11           : ORIGIN = 0xFFF6, LENGTH = 0x0002  /* Comparator A */
  VECT12           : ORIGIN = 0xFFF8, LENGTH = 0x0002  /* Timer B CCR1 */
  VECT13           : ORIGIN = 0xFFFA, LENGTH = 0x0002  /* Timer B CCR0 */
  VECT14           : ORIGIN = 0xFFFC, LENGTH = 0x0002  /* NMI */
  RESETVEC         : ORIGIN = 0xFFFE, LENGTH = 0x0002  /* Reset */
  
  /* Reset jump code at start of flash */
  RSTJMP           : ORIGIN = 0x4000, LENGTH = 0x0010
}

SECTIONS{
  /* MMIO section - reserve space but don't put anything here */
  .mmio (NOLOAD) : {
    __mmio_start = .;
    . = . + __mmio_size;
    __mmio_end = .;
  } > MMIO
  
  /* MSP430F1611 interrupt vectors (only 15 + reset) */
  __interrupt_vector_0   : { KEEP (*(__interrupt_vector_0 )) KEEP (*(__interrupt_vector_basictimer)) } > VECT0
  __interrupt_vector_1   : { KEEP (*(__interrupt_vector_1 )) KEEP (*(__interrupt_vector_port2)) } > VECT1
  __interrupt_vector_2   : { KEEP (*(__interrupt_vector_2 )) KEEP (*(__interrupt_vector_usart1_tx)) } > VECT2
  __interrupt_vector_3   : { KEEP (*(__interrupt_vector_3 )) KEEP (*(__interrupt_vector_usart1_rx)) } > VECT3
  __interrupt_vector_4   : { KEEP (*(__interrupt_vector_4 )) KEEP (*(__interrupt_vector_port1)) } > VECT4
  __interrupt_vector_5   : { KEEP (*(__interrupt_vector_5 )) KEEP (*(__interrupt_vector_timera1)) } > VECT5
  __interrupt_vector_6   : { KEEP (*(__interrupt_vector_6 )) KEEP (*(__interrupt_vector_timera0)) } > VECT6
  __interrupt_vector_7   : { KEEP (*(__interrupt_vector_7 )) KEEP (*(__interrupt_vector_adc12)) } > VECT7
  __interrupt_vector_8   : { KEEP (*(__interrupt_vector_8 )) KEEP (*(__interrupt_vector_usart0_tx)) } > VECT8
  __interrupt_vector_9   : { KEEP (*(__interrupt_vector_9 )) KEEP (*(__interrupt_vector_usart0_rx)) } > VECT9
  __interrupt_vector_10  : { KEEP (*(__interrupt_vector_10)) KEEP (*(__interrupt_vector_wdt)) } > VECT10
  __interrupt_vector_11  : { KEEP (*(__interrupt_vector_11)) KEEP (*(__interrupt_vector_comparatora)) } > VECT11
  __interrupt_vector_12  : { KEEP (*(__interrupt_vector_12)) KEEP (*(__interrupt_vector_timerb1)) } > VECT12
  __interrupt_vector_13  : { KEEP (*(__interrupt_vector_13)) KEEP (*(__interrupt_vector_timerb0)) } > VECT13
  __interrupt_vector_14  : { KEEP (*(__interrupt_vector_14)) KEEP (*(__interrupt_vector_nmi)) } > VECT14
  
  __reset_vector :
  {
    KEEP (*(__interrupt_vector_15))
    KEEP (*(__interrupt_vector_reset))
    KEEP (*(.resetvec))
  } > RESETVEC
  
  __rstjmp :
  {
    KEEP (*(.rstjmp))
  } > RSTJMP
}

INCLUDE picolibc.ld