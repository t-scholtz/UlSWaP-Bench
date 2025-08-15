#include <stdio.h>

void putchar_uart(int c);
int getchar_uart();

// Simple insertion sort to sort the array after getchar_uarting values
void sort_array(int arr[], int n) {
    int i, key, j;
    for (i = 1; i < n; i++) {
        key = arr[i];
        j = i - 1;
        
        // Move elements greater than key one position ahead
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}

// Iterative binary search function
int binary_search(int arr[], int low, int high, int x) {
    while (low <= high) {
        int mid = low + (high - low) / 2;
        
        // Check if x is present at mid
        if (arr[mid] == x)
            return mid;
        
        // If x greater, ignore left half
        if (arr[mid] < x)
            low = mid + 1;
        
        // If x is smaller, ignore right half
        else
            high = mid - 1;
    }
    
    // Element not found
    return -1;
}

int benchmark_main(void) {
    int size = 5;
    int arr[size];
    int i;
    int search_value;
    int result;
    
    for (i = 0; i < size; i++) {
        arr[i] = getchar_uart();
    }

    sort_array(arr, size);

    search_value = getchar_uart();
    
    // Perform binary search
    result = binary_search(arr, 0, size-1, search_value);

    putchar_uart(result);
    
    return 0;
}