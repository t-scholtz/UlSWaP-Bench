#include <stdio.h>

void putchar_uart(int c);
int getchar_uart();

void insertionSort(int arr[], int N) {

    for (int i = 1; i < N; i++) {
        int key = arr[i];
        int j = i - 1;

        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }

        arr[j + 1] = key;
    }
}

int benchmark_main() {
    int N = 10;
    int arr[N];
    int i;
    
    for (i = 0; i < N; i++) {
        arr[i] = getchar_uart();
    }
    insertionSort(arr, N);

    for (i = 0; i < N; i++) {
        putchar_uart(arr[i]);
    }

    return 0;
}