#include <stdio.h>
#include "common.h"

int benchmark_main(void);

#ifndef RUNS
#define RUNS 1
#endif  // RUNS


int main(void)
{
#ifdef CUSTOM_ARCH_STARTUP
    run_arch_startup();
#endif  // CUSTOM_ARCH_STARTUP

    for (int run = 0; run < RUNS; ++run)
    {
        benchmark_main();
    }
    return 0;
}
