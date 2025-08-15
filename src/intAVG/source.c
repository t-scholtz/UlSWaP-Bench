#include <stdio.h>

void putchar_uart(int c);
int getchar_uart();

int benchmark_main(void) {
    int size = 10;
    int total = 0;
    int result;
    
    for (int i = 0; i < size; i++) {
        total += getchar_uart();
    }

    result =  total/size;

    putchar_uart(result);
    
    return 0;
}