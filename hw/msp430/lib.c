volatile int * const MMIO_IN = (int *)0xFFD0;
volatile int * const MMIO_OUT = (int *)0xFFD4;

int getchar_uart(void) {
    return *MMIO_IN;
}

void putchar_uart(int value) {
    *MMIO_OUT = value;
}
