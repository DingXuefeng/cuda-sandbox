#include <stdio.h>
#include "lib2.h"
namespace lib2 {
  __device__ float x;
  __device__ void call() {
#ifdef __CUDACC__
    atomicAdd(&x, float((threadIdx.x+0.5)*(blockIdx.x+0.5)));
    printf("lib2::call() %d: %d %d -> %lf \n",__LINE__,blockIdx.x,threadIdx.x,x);
#else
    x+= 1;
#endif
  }
}
