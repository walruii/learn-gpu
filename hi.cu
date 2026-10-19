#include <stdio.h>

__global__ void helloFromGPU() { printf("Hello, World from the GPU!\n"); }

int main() {
  printf("Hello, World From the CPU!\n");
  helloFromGPU<<<2, 2>>>();
  cudaDeviceSynchronize();

  return 0;
}
