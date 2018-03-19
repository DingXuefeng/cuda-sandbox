#include <iostream>
#include <string>
#include <stdexcept>

#include <thrust/functional.h> // for binary_function
#include <thrust/host_vector.h> // for binary_function
#include <thrust/device_vector.h> // for binary_function
#include <functional>
struct BinaryOp: public thrust::binary_function<float,float,float> {
  sum(std::function<float(float,float) f) : m_f(f) { }
  __device__ float operator()(float x,float y) const {
    return f(x,y);
  }
};
float sum(float x,float y) { return x+y; }
void test ( struct sum *op) {
  const int N = 1<<10;

  thrust::host_vector<float> x_th_host_v;
  thrust::host_vector<float> y_th_host_v;
  for (int i = 0; i < N; i++) {
    x_th_host_v.push_back(i+0.0f);
    y_th_host_v.push_back(i+0.5f);
  }
  thrust::device_vector<float> x_th_dev_v(x_th_host_v);
  thrust::device_vector<float> y_th_dev_v(y_th_host_v);

  thrust::transform(x_th_dev_v.begin(),x_th_dev_v.end(),y_th_dev_v.begin(),y_th_dev_v.begin(),*op);

  y_th_host_v = y_th_dev_v;

  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;
  for (int i = 0; i < N; i++) {
    maxError = fmax(maxError, fabs(y_th_host_v[i]-3.0f));
  }
  std::cout << "Max error: " << maxError << std::endl;
}
void logLL() {
  test(new BinaryOp(sum));
}
void RPF() {
}
void MVLL() {
}
