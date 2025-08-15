#include <msp430.h>
#include <stdio.h>
#include <stddef.h>
#include "lib.c"

static int sendByte(char byte, FILE *file);

void initClocks(void){
    // MSP430F1611 uses basic clock module, not CS module
    // Set DCO to ~8MHz (max for MSP430F1611)
    DCOCTL = DCO2 | DCO1 | DCO0;           // Max DCO setting
    BCSCTL1 = RSEL2 | RSEL1 | RSEL0;       // Max range select (RSEL3 doesn't exist on F1611)
    
    // Configure clocks:
    // MCLK = DCO (~8MHz)
    // SMCLK = DCO (~8MHz) 
    // ACLK = LFXT1 (32768 Hz, if crystal present)
    BCSCTL2 = SELM_0 | DIVM_0 | SELS | DIVS_0;
}


void run_arch_startup(){
    // Stop watchdog (already done in assembly, but be safe)
    WDTCTL = WDTPW | WDTHOLD;
    
    // Peripheral init
    initClocks();
    
    // MSP430F1611 doesn't have PM5CTL0 (that's FRAM-specific)
    // Instead, configure ports as needed:
    P1DIR = 0x00;  // All inputs by default
    P2DIR = 0x00;  // All inputs by default  
    P3DIR = 0x00;  // All inputs by default
    P4DIR = 0x00;  // All inputs by default
    P5DIR = 0x00;  // All inputs by default
    P6DIR = 0x00;  // All inputs by default
    
    // Enable interrupts
    __bis_SR_register(GIE);
}

void print_hexstring(unsigned int num){
    for (unsigned int i = sizeof(num) * 8; i > 0; i -= 4){
        char nibble = (num >> (i - 4)) & 0xF;
        if (nibble > 9){
            sendByte(nibble + 0x37, NULL);  // 'A'-'F'
        } else {
            sendByte(nibble + 0x30, NULL);  // '0'-'9'
        }
    }
}

void hexstring(unsigned int num){
    print_hexstring(num);
    sendByte('\r', NULL);
    sendByte('\n', NULL);
}

void hexstrings(unsigned int num){
    print_hexstring(num);
    sendByte(' ', NULL);
}

// Set up handles for picolibc stdout  
static int sendByte(char byte, FILE *file){
    putchar_uart(byte);
    return byte;
}

static FILE __stdio = FDEV_SETUP_STREAM(sendByte, NULL, NULL, _FDEV_SETUP_WRITE);
FILE *const stdout = &__stdio;
__strong_reference(stdout, stdin);
__strong_reference(stdin, stderr);