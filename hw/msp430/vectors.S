#include <msp430.h>

/* MMIO Addresses for simulation control */
#define SIM_END      0xFFD8    /* Simulation end signal */

.section .resetvec,"ax"
.word rst                     
.extern _start

.section .text                 
.global rst
rst:
  MOV #WDTPW|WDTHOLD, &WDTCTL  /* Disable watchdog timer */
  br #_start                   /* Branch to picolibc startup */

.global _exit
_exit:
  MOV #0xDEAD, &SIM_END       /* Sudo Ebreak - signal simulation end */
  
_exit_loop:                   
  br #_exit_loop              /* Infinite loop */