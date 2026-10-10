#include <stdio.h>

__global__ void stencil_1d(int *in, int *out, int n) {
  __shared__ int temp[258];
  int tid = threadIdx.x;
  int idx = blockIdx.x * blockDim.x + threadIdx.x;

  // Collaborative Loading: Load main element into shared memory
  if (idx < n) { temp[tid + 1] = in[idx]; }
  else { temp[tid + 1] = 0; }

  // Loading Boundary (halo) elements
  if (tid == 0) {
    temp[0] = (idx == 0) ? 0 : in[idx - 1];
  }
  if (tid == blockDim.x - 1) {
    temp[tid + 2] = (idx == n - 1) ? 0 : in[idx + 1];
  }

  // BARRIER SYNCHRONIZATION
  __syncthreads();

  if (idx < n) {
    out[idx] = temp[tid] + temp[tid + 1] + temp[tid + 2];
  }

}

int main() {
  int n = 10;
  int bytes = n * sizeof(int);

  int h_in[] = {1,2,3,4,5,6,7,8,9,10};
  int h_out[10];

  int *d_in, *d_out;
  cudaMalloc(&d_in, bytes);
  cudaMalloc(&d_out, bytes);

  cudaMemcpy(d_in, h_in, bytes, cudaMemcpyHostToDevice);

  stencil_1d<<<1, 256>>>(d_in, d_out, n);

  cudaMemcpy(h_out, d_out, bytes, cudaMemcpyDeviceToHost);

  printf("Input: ");
  for (int i = 0; i < n; i++) printf("%d ", h_in[i]);
  printf("\n");
  printf("Output (sum of neighbors): ");
  for(int i = 0; i < n; i++) printf("%d ", h_out[i]);
  printf("\n");


  return 0;
}
