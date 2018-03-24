#ifndef for_cc_h
#define for_cc_h
#ifdef __CUDACC__
#else
struct T {
  int x;
}; 
extern T threadIdx;
extern T blockIdx;
extern T blockDim;
#endif
#endif
