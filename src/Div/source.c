#include <stdio.h>

void putchar_uart(int c);
int getchar_uart();

int benchmark_main() {
    int a = getchar_uart();
    int b = getchar_uart();
    int c = a / b;
    putchar_uart(c);
    return 0;
}
