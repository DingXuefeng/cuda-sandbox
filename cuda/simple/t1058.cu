#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/copy.h>
#include <iostream>

typedef float(*fptr_t)(const float&);

template <fptr_t F>
struct functor{

    __host__ __device__ float operator()(const float& x) const {
              return F(x);
	          }
};

__host__ __device__ float g(const float& x){return 3*x;}


int main(void){
  thrust::device_vector<float> X(4,1);
  thrust::transform(X.begin(), X.end(), X.begin(), functor<g>());
  thrust::copy_n(X.begin(), X.size(), std::ostream_iterator<float>(std::cout, ","));
  std::cout << std::endl;
}
