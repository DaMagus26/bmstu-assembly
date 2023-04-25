#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

void swap(int *a, int *b) {
  int temp = *a;
  *a = *b;
  *b = temp;
}

void transpose(int* matrix, int *rows, int *cols) {
    int size = *rows * *cols;
    int *hash = malloc(sizeof(char) * *rows * *cols);
    int current_item;
    int next_location;
    int cycle_begin;
    int i;

    memset(hash, 0, sizeof hash);
    hash[0] = 1;
    hash[1] = 1;
    i = 1;

    while (i < size-1) {
        cycle_begin = i;
        current_item = matrix[i];

        do {
            next_location = (i * *rows) % (size - 1);
            swap(&matrix[next_location], &current_item);
            hash[i] = 1;
            i = next_location;
        } while (i != cycle_begin);
        
        for (i = 1; i < (size - 1) && hash[i]; ++i);
    }

    swap(rows, cols);
}

int main() {
    int n;
    int m;

    printf("Enter number of rows: ");    
    scanf("%d", &n);
    printf("Enter number of columns: ");    
    scanf("%d", &m);

    printf("Enter a matrix:\n");    
    int* matrix = malloc(sizeof(int) * m * n);

    for (int i = 0; i < n * m; ++i) {
        scanf("%d", &matrix[i]);
    }

    // for (int i = 0; i < n; ++i) {
    //     for (int j = 0; j < m; ++j) {
    //         printf("%d ", matrix[i * m + j]);
    //    }
    //    printf("\n");
    // }

    // Transpose matrix
    transpose(matrix, &n, &m);

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            printf("%d ", matrix[i * m + j]);
       }
       printf("\n");
    }

    return 0;
}