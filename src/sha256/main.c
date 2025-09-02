#include <stdio.h>
#include <stdint.h>
#include "sha256.h"
#include "common.h"

#define DIGEST_BYTES (256/8)
void putchar_uart(int c);
int getchar_uart();

void print_hash(uint8_t *hash) {
    for (int i = 0; i < DIGEST_BYTES; i++) {
        putchar_uart(hash[i]);
    }
}

/* entry point used by your test harness */
int benchmark_main() {

    SHA256_CTX ctx;
    uint8_t hash[DIGEST_BYTES];
    unsigned char data[256];

    for (int i = 0; i < 256; ++i) {
        int c = getchar_uart();
        data[i] = (unsigned char)c;
    }

    sha256_init(&ctx);
    sha256_update(&ctx, data, 256);    /* use explicit length for binary data */
    sha256_final(&ctx, hash);

    print_hash(hash);

    return 0;
}
