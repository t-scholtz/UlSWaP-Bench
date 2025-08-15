volatile int * const MMIO_IN = (int *)0x40000000;
volatile int * const MMIO_OUT = (int *)0x40000004;

/* Remove 'static inline' to make functions globally visible */
int getchar_uart(void) {
    return *MMIO_IN;
}

void putchar_uart(int value) {
    *MMIO_OUT = value;
}