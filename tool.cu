#include <iostream>
#include <string>
#include <stdexcept>

#include <thrust/functional.h> // for binary_function
#include <thrust/host_vector.h> // for binary_function
#include <thrust/device_vector.h> // for binary_function

typedef float (*nvstdfunction)(float x,float y);

#define MEMCPY_TO_SYMBOL(target, source, count, offset, direction) \
  do { cudaError_t ret = cudaMemcpyToSymbol(target, source, count, offset, direction); \
      if(ret!=cudaSuccess) throw runtime_error(string(cudaGetErrorString(ret))); } while(0)

#define TEST(OP_PTR)  \
  do { void *address; \
  cudaError_t ret = cudaGetSymbolAddress(&address, OP_PTR ## _ptr); \
  if(ret!=cudaSuccess) { std::cout<<"on line "<<__LINE__<<std::endl; throw std::runtime_error(std::string(cudaGetErrorString(ret))); } \
  test(new BinaryOp(address)); } while (0);

#include "fun.icc"

#define REGISTER(fun) \
__device__ nvstdfunction fun ## _ptr = fun;
REGISTER(logLLdev)
REGISTER(RPFdev)
REGISTER(MVLLdev20)
REGISTER(MVLLdev50)
REGISTER(MVLLdev70)

struct BinaryOp: public thrust::binary_function<float,float,float> {

  BinaryOp(void *address) { 
    cudaError_t ret = cudaMemcpy(&m_f, address, sizeof(void*),cudaMemcpyDeviceToHost);
    if(ret!=cudaSuccess) throw std::runtime_error(std::string(cudaGetErrorString(ret)));
  }

  __device__ float operator()(float x,float y) const {
    return (*(reinterpret_cast<nvstdfunction>(m_f)))(x,y);
  }
  void *m_f;

};

void test ( struct BinaryOp*op) {
  const int N = 1<<10;

  thrust::host_vector<float> x_th_host_v;
  thrust::host_vector<float> y_th_host_v;
  for (int i = 0; i < N; i++) {
    x_th_host_v.push_back(1.0f);
    y_th_host_v.push_back(2.0f);
  }
  thrust::device_vector<float> x_th_dev_v(x_th_host_v);
  thrust::device_vector<float> y_th_dev_v(y_th_host_v);

  thrust::transform(x_th_dev_v.begin(),x_th_dev_v.end(),y_th_dev_v.begin(),y_th_dev_v.begin(),*op);

  y_th_host_v = y_th_dev_v;

//  std::cout<<y_th_host_v[0]<<std::endl;
}
void logLL() {
  TEST(logLLdev)
}
void RPF() {
  TEST(RPFdev)
}
void MVLL() {
  TEST(MVLLdev20)
  TEST(MVLLdev50)
  TEST(MVLLdev70)
}
