### CMakeLists.txt for CUDA

cmake_minimum_required(VERSION 3.4)
find_package(CUDA QUIET REQUIRED)

set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS};-std=c++11;-G;-g;-lineinfo;--compiler-options;-Wall,-Wextra,-Werror=return-type;-gencode arch=compute_13,code=sm_13")

cuda_add_executable(main main.cu)
