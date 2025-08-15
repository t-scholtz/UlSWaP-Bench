#include <stdio.h>

void putchar_uart(int c);
int getchar_uart();

int benchmark_main() {
    int a = getchar_uart();
    int b = getchar_uart();

    // Arithmetic operations
    putchar_uart(a + b);        // sum
    putchar_uart(a - b);        // diff
    putchar_uart(a * b);        // prod
    putchar_uart(a / b); // quot
    putchar_uart(a % b); // mod

    // Bitwise operations
    putchar_uart(a & b);        // and
    putchar_uart(a | b);        // or
    putchar_uart(a ^ b);        // xor
    putchar_uart(~a);           // not a
    putchar_uart(~b);           // not b

    // Bit shifts
    putchar_uart(a << 2);       // left shift a
    putchar_uart(b >> 2);       // right shift b

    // Unary operations
    putchar_uart(-a);           // negation
    putchar_uart(+b);           // unary plus

    // Compound assignment simulation
    int mix = a;
    mix += b;
    putchar_uart(mix);          // mix += b
    mix -= 1;
    putchar_uart(mix);          // mix -= 1
    mix *= 2;
    putchar_uart(mix);          // mix *= 2
    mix >>= 1;
    putchar_uart(mix);          // mix >>= 1

    // Logical operations
    putchar_uart(a && b);     // logical and
    putchar_uart(a || b);     // logical or
    putchar_uart(!a);         // logical not

    return 0;
}
