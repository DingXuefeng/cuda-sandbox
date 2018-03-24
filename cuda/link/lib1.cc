#include "lib1.h"
#include "lib2.h"
#include <stdio.h>

namespace lib1 {
  __device__ void call() {
    lib2::call();
    printf("lib1::call() %d: %d %d -> %lf \n",__LINE__,blockIdx.x,threadIdx.x,3.14);
  }
}
