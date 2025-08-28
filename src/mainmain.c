#include <stdio.h>
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
    return 0;
}
