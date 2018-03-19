### CMakeLists.txt for CUDA

cmake_minimum_required(VERSION 3.4)
find_package(CUDA QUIET REQUIRED)
#find_package(Thrust REQUIRED)

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
# Pass options to NVCC
#set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS};--compiler-options;-Werror,-Wall,-Wextra,-Werror=return-type")
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS};-std=c++11;-G;-g;-lineinfo;--compiler-options;-Wall,-Wextra,-Werror=return-type")

# Specify include directories
#include_directories(
#    kernels
#    utility
#    )

# Specify library paths
#link_directories(
#    /opt/foobar/lib
#    /opt/joestuff/lib
#    )

# For compilation ...
# Specify target & source files to compile it from
cuda_add_library(
  func_cuda
  fun.cu
  )
cuda_add_executable(
  timer
  timer.cc
  )
target_link_libraries(timer func_cuda)

# For linking ...
# Specify target & libraries to link it with
#target_link_libraries(
#    hellocuda
#    -lfoobar
#    -ljoestuff
#    )
target_compile_features(timer PRIVATE cxx_range_for)
