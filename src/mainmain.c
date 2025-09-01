#include <stdio.h>
#include <stdlib.h>   // for exit()
#include "common.h"

int benchmark_main(void);

#ifndef RUNS
#define RUNS 1
#endif  // RUNS

int main(void)
{
    for (int run = 0; run < RUNS; ++run)
    {
        benchmark_main();
    }

    #ifdef ARCH_MSP430
        // MSP430 doesn't like return 0
        exit(0);
    #else
        return 0;
    #endif
}
