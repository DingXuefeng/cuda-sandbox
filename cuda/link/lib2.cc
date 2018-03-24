#include <stdio.h>
#include "lib2.h"
#ifdef __CUDACC__
#else
T threadIdx { 10 };
#endif
namespace lib2 {
  __device__ float x;
  __device__ void call() {
    atomicAdd(&x, float((threadIdx.x+0.5)*(blockIdx.x+0.5)));
    printf("lib2::call() %d: %d %d -> %lf \n",__LINE__,blockIdx.x,threadIdx.x,x);
  }
}
