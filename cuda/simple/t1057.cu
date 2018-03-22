#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/copy.h>
#include <iostream>
struct functor{
  functor(float (*g)(const float&)) : _g{g} {}

  __host__ __device__ float operator()(const float& x) const {
    return _g(x);
  }
  private:
  float (*_g)(const float&);
};

__host__ __device__ float g(const float& x){return 3*x;}

__device__ float (*d_g)(const float&) = g;

int main(void){
  float (*h_g)(const float&) = NULL;
  cudaMemcpyFromSymbol(&h_g, d_g, sizeof(void *));
  thrust::device_vector<float> X(4,1);
  thrust::transform(X.begin(), X.end(), X.begin(), functor(h_g));
  thrust::copy_n(X.begin(), X.size(), std::ostream_iterator<float>(std::cout, ","));
  std::cout << std::endl;
}
