// Based on TEA implementation from - https://github.com/coderarjob/tea-c

#include <stdio.h>
#include <stdint.h>

void putchar_uart(int c);
int getchar_uart();

// Tiny Encryption Algorithm (TEA)
void code(uint32_t *v, uint32_t *k) {
    uint32_t v0 = v[0], v1 = v[1];
    uint32_t sum = 0, delta = 0x9e3779b9;
    for (int i = 0; i < 32; i++) {
        sum += delta;
        v0 += ((v1 << 4) + k[0]) ^ (v1 + sum) ^ ((v1 >> 5) + k[1]);
        v1 += ((v0 << 4) + k[2]) ^ (v0 + sum) ^ ((v0 >> 5) + k[3]);
    }
    v[0] = v0;
    v[1] = v1;
}

void decode(uint32_t *v, uint32_t *k) {
    uint32_t v0 = v[0], v1 = v[1];
    uint32_t sum = 0x9e3779b9 * 32, delta = 0x9e3779b9;
    for (int i = 0; i < 32; i++) {
        v1 -= ((v0 << 4) + k[2]) ^ (v0 + sum) ^ ((v0 >> 5) + k[3]);
        v0 -= ((v1 << 4) + k[0]) ^ (v1 + sum) ^ ((v1 >> 5) + k[1]);
        sum -= delta;
    }
    v[0] = v0;
    v[1] = v1;
}

// benchmark_main fuzzing-compatible TEA routine
void benchmark_main() {
    uint32_t key[4] = {123, 456, 789, 1011};
    int num_blocks = 2;

    for (int i = 0; i < num_blocks; i++) {
        uint32_t block[2];

        // getchar_uart two words (64-bit block)
        block[0] = getchar_uart();
        block[1] = getchar_uart();
        
        code(block, key);

        putchar_uart(block[0]);
        putchar_uart(block[1]);

        decode(block, key);

        putchar_uart(block[0]);
        putchar_uart(block[1]);
    }
    return;
}
