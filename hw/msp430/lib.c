volatile int * const MMIO_IN = (int *)0x0002;
volatile int * const MMIO_OUT = (int *)0x0004;

int getchar_uart(void) {
    return *MMIO_IN;
}

void putchar_uart(int value) {
    *MMIO_OUT = value;
}
