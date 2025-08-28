#include <msp430.h>

#define SIM_END 0x0006

.section .resetvec,"ax"
.word 0x4000

.extern _start

.section .rstjmp,"ax"
.global rst
rst:
  jmp _start

.global _exit
_exit:
    mov.w   #0xDEAD, &SIM_END   /* Signal simulation end */
    nop
_exit_loop:
    jmp     _exit_loop          /* Infinite loop */

