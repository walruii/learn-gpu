#include <stdio.h>

__global__ void addVectors(int *a, int *b, int *c, int n) {
  int i = threadIdx.x;
  if (i < n) {
    c[i] = a[i] + b[i];
  }
}

int main() {
  int n = 5;

  int h_a[] = {1,2,3,4,5};
  int h_b[] = {10,20,30,40,50};
  int h_c[5];

  int *d_a, *d_b, *d_c;

  cudaMalloc(&d_a, n * sizeof(int));
  cudaMalloc(&d_b, n * sizeof(int));
  cudaMalloc(&d_c, n * sizeof(int));

  cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b, n * sizeof(int), cudaMemcpyHostToDevice);

  addVectors<<<1, n>>>(d_a, d_b, d_c, n);

  cudaMemcpy(h_c, d_c, n * sizeof(int), cudaMemcpyDeviceToHost);

  printf("Result of vector addition: ");
  for (int i = 0; i < n; i++) {
    printf("%d ", h_c[i]);
  }
  printf("\n");

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  return 0;

}
