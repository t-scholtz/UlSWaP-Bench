// Based on Michael Dipperstein's RLE algorithm - https://github.com/MichaelDipperstein/rle
// Adapted for bare-metal environment with fixed-size input block

#include <stdio.h>

void putchar_uart(int c);
int getchar_uart();

#define BLOCK_SIZE 4
#define MAX_ENCODED_SIZE 2 * BLOCK_SIZE  // Worst-case: no compression
#define MAX_DECODED_SIZE BLOCK_SIZE

// Encode a fixed-size block of 4 integers
int rle_encode_block(int *input, int *encoded) {
    int in_idx = 0, out_idx = 0;
    int prev = -1;
    unsigned char count = 0;

    while (in_idx < BLOCK_SIZE) {
        int curr = input[in_idx++];
        encoded[out_idx++] = curr;

        if (curr == prev) {
            count = 0;

            while (in_idx < BLOCK_SIZE && input[in_idx] == prev) {
                count++;
                in_idx++;

                if (count == 255)
                    break;
            }

            encoded[out_idx++] = count;
            prev = -1;
        } else {
            prev = curr;
        }
    }

    return out_idx;  // Return the number of encoded values
}

// Decode a previously encoded block
int rle_decode_block(int *encoded, int encoded_len, int *decoded) {
    int in_idx = 0, out_idx = 0;
    int prev = -1;

    while (in_idx < encoded_len) {
        int curr = encoded[in_idx++];
        decoded[out_idx++] = curr;

        if (curr == prev && in_idx < encoded_len) {
            int count = encoded[in_idx++];
            while (count-- > 0 && out_idx < MAX_DECODED_SIZE) {
                decoded[out_idx++] = curr;
            }
            prev = -1;
        } else {
            prev = curr;
        }
    }

    return out_idx;  // Return number of decoded values
}

void benchmark_main() {
    int input[BLOCK_SIZE];
    int encoded[MAX_ENCODED_SIZE];
    int decoded[MAX_DECODED_SIZE];

    for (int i = 0; i < BLOCK_SIZE; i++) {
        input[i] = getchar_uart();
    }

    // Encode the block
    int enc_len = rle_encode_block(input, encoded);

    for (int i = 0; i < enc_len; i++) {
        putchar_uart(encoded[i]);
    }

    // Decode the encoded block
    int dec_len = rle_decode_block(encoded, enc_len, decoded);

    for (int i = 0; i < dec_len; i++) {
        putchar_uart(decoded[i]);
    }

    return;
}
