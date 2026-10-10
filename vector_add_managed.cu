#include <stdio.h>

__global__ void addVectors(int *a, int *b, int *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

int main() {
  int n = 1'000'000;
  int bytes = n * sizeof(int);

  int *a, *b, *c;
  cudaMallocManaged(&a, bytes);
  cudaMallocManaged(&b, bytes);
  cudaMallocManaged(&c, bytes);

  for (int i = 0; i < n; i++) {
    a[i] = 1;
    b[i] = 2;
  }

  int threadsPerBlock = 256;
  int numBlocks = (n + threadsPerBlock - 1) / threadsPerBlock;
  addVectors<<<numBlocks, threadsPerBlock>>>(a,b,c,n);

  cudaDeviceSynchronize();

  printf("First 5 elements: ");
  for (int i = 0; i < 5; i++) {
    printf("%d ", c[i]);
  }
  printf("\n");
  cudaFree(a);
  cudaFree(b);
  cudaFree(c);

  return 0;
}
