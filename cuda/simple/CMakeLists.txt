### CMakeLists.txt for CUDA

cmake_minimum_required(VERSION 2.8)
find_package(CUDA REQUIRED)

MESSAGE( STATUS "c compiler used: " ${CMAKE_C_COMPILER} )
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS};-std=c++11;-G;-g;-lineinfo;--compiler-options;-Wall,-Wextra,-Werror=return-type;-gencode arch=compute_35,code=sm_35")

cuda_add_executable(main main.cu)
cuda_add_executable(t1057 t1057.cu)
cuda_add_executable(t1058 t1058.cu)
