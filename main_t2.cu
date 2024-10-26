#include <stdio.h>
#include <cuda_runtime.h>

__global__ void add(int* a, int* b, int* c) {
    int i = threadIdx.x + blockDim.x * blockIdx.x;
    // if (i < 256) {
        c[i] = a[i] + b[i];
    // }
}

int main() {
    printf("Devara Red Sea...\n");

    int *vector_a, *vector_b, *vector_c;

    // Allocate memory on the device (GPU)
    cudaMalloc(&vector_a, 256 * sizeof(int));
    cudaMalloc(&vector_b, 256 * sizeof(int));
    cudaMalloc(&vector_c, 256 * sizeof(int));

    // Allocate temporary arrays on host
    int h_vector_a[256], h_vector_b[256], h_vector_c[256];

    // Initialize vectors on host
    for (int i = 0; i < 256; i++) {
        h_vector_a[i] = i;
        h_vector_b[i] = 256 - i;
    }

    // Copy vectors from host to device
    cudaMemcpy(vector_a, h_vector_a, 256 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(vector_b, h_vector_b, 256 * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel with 256 threads
    add<<<1, 256>>>(vector_a, vector_b, vector_c);

    // Synchronize device
    cudaDeviceSynchronize();

    // Copy result back from device to host
    cudaMemcpy(h_vector_c, vector_c, 256 * sizeof(int), cudaMemcpyDeviceToHost);

    // Compute the result sum on the host
    int result_sum = 0;
    for (int i = 0; i < 256; i++) {
        result_sum += h_vector_c[i];
    }

    printf("Done... Result: %d\n", result_sum);

    // Free device memory
    cudaFree(vector_a);
    cudaFree(vector_b);
    cudaFree(vector_c);

    return 0;
}
