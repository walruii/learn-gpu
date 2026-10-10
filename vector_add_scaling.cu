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

  int *h_a = (int*)malloc(bytes);
  int *h_b = (int*)malloc(bytes);
  int *h_c = (int*)malloc(bytes);

  for (int i = 0; i < n; i++) {
    h_a[i] = 1;
    h_b[i] = 2;
  }

  int *d_a, *d_b, *d_c;

  cudaMalloc(&d_a, bytes);
  cudaMalloc(&d_b, bytes);
  cudaMalloc(&d_c, bytes);

  cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

  int threadsPerBlock = 256;
  int numBlocks = (n + threadsPerBlock - 1)/ threadsPerBlock;

  addVectors<<<numBlocks, threadsPerBlock>>>(d_a, d_b, d_c, n);

  cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

  printf("Result is: ");
  for (int i = 0; i < 10; i++) {
    printf("%d ", h_c[i]);
  }
  printf("\n");

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
  free(h_a);
  free(h_b);
  free(h_c);

  return 0;
}
