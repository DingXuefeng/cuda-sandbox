#include <stdio.h>

__constant__ int const_symbol;

/********************/
/* CUDA ERROR CHECK */
/********************/
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

/***************/
/* TEST KERNEL */
/***************/
__global__ void kernel() {

    printf("Address of symbol from device = %p\n", &const_symbol);

}

/********/
/* MAIN */
/********/
int main() 
{
    const int N = 16;
    int *pointer = NULL;

    gpuErrchk(cudaGetSymbolAddress((void**)&pointer, const_symbol));

    kernel<<<1,1>>>();

    printf("Address of symbol from host = %p\n", pointer);

    return 0;
}

