#include <iostream>
typedef float (*fun)(float,float);
__host__ __device__ float sum(float x,float y) { return x+y; }
//__device__ fun m = sum;
__device__ float (*m)(float, float) = sum;
int main() {
  void *addr;
  cudaError_t ret = cudaGetSymbolAddress(&addr,m);
  std::cout<<addr<<" "<<cudaGetErrorString(ret)<<std::endl;

  return 0;
}
