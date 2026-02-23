#include <stdio.h>

#define N 10
#define ADD_VALUE 42

__global__ void vector_add(int *vec, int value, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < n) {
        printf("  Thread %d (block %d, threadIdx %d): vec[%d] = %d + %d = %d\n",
               idx, blockIdx.x, threadIdx.x, idx, vec[idx], value, vec[idx] + value);
        vec[idx] += value;
    }
}

int main(void) {
    int h_vec[N];
    int *d_vec;

    // Fill vector with values: 10, 20, 30, ...
    printf("Input vector:\n  ");
    for (int i = 0; i < N; i++) {
        h_vec[i] = (i + 1) * 10;
        printf("%d ", h_vec[i]);
    }
    printf("\n\nAdding %d to each element in parallel...\n\n", ADD_VALUE);

    // Allocate device memory and copy data to GPU
    cudaMalloc(&d_vec, N * sizeof(int));
    cudaMemcpy(d_vec, h_vec, N * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel: 1 block, 10 threads (one thread per element)
    int threads_per_block = N;
    int num_blocks = 1;

    printf("Launch config: %d block(s), %d thread(s) per block\n\n", num_blocks, threads_per_block);
    vector_add<<<num_blocks, threads_per_block>>>(d_vec, ADD_VALUE, N);
    cudaDeviceSynchronize();

    // Copy result back to host
    cudaMemcpy(h_vec, d_vec, N * sizeof(int), cudaMemcpyDeviceToHost);

    printf("\nResult vector:\n  ");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_vec[i]);
    }
    printf("\n");

    cudaFree(d_vec);
    return 0;
}
