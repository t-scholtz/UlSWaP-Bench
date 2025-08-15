#include <stdio.h>

void putchar_uart(int c);
int getchar_uart();

#define THRESHOLD 100

void benchmark_main() {
    int input;
    int num_of_inputs = 5;

    for(int i = 0; i < num_of_inputs; i++) {
        input = getchar_uart();
        if (input >= THRESHOLD) {
            putchar_uart(1);
        } else {
            putchar_uart(0);
        }
    }
}
