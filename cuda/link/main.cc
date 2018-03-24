#include <iostream>
#include <stdio.h>
#include <cuda_runtime.h>
#include "lib1.h"
#ifdef __CUDACC__
#else
#include <string.h> // for memcpy
#endif
__global__ void call(double *x) {
  lib1::call();
  int index = blockIdx.x*blockDim.x + threadIdx.x;
  x[index] = (threadIdx.x+0.5)*(blockIdx.x+0.5);
  printf("inside %d: %d %d -> %lf \n",__LINE__,blockIdx.x,threadIdx.x,x[index]);
}
namespace lib2 {
  extern __device__ double x;
}
int main() {
  double *data;
#ifdef __CUDACC__
  cudaError_t ret;
  ret = cudaMalloc(&data,100*sizeof(double));
  if(ret!=cudaSuccess) std::cout<<cudaGetErrorString(ret)<<" -> "<<__LINE__<<std::endl;
  call<<<2,2>>>(data);
#else
  call();
#endif
  float x;
#ifdef __CUDACC__
  ret = cudaMemcpyFromSymbol(&x, lib2::x, sizeof(float));
  if(ret!=cudaSuccess) std::cout<<cudaGetErrorString(ret)<<" -> "<<__LINE__<<std::endl;
  double y[100];
  ret = cudaMemcpy(y, data, 100*sizeof(double),cudaMemcpyDeviceToHost);
  if(ret!=cudaSuccess) std::cout<<cudaGetErrorString(ret)<<" -> "<<__LINE__<<std::endl;
  std::cout<<y[0]<<" "<<y[1]<<std::endl;
#else
  memcpy(&x, &lib2::x, sizeof(double));
  cudaFree(data);
#endif
  std::cout<<x<<std::endl;
  return 0;
}
