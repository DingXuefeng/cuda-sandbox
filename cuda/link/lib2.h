#include <cuda_runtime.h>
namespace lib2 {
  extern __device__ float x;
  __device__ void call();
}
#ifdef __CUDACC__
#else
struct T {
  int x;
};
#endif
