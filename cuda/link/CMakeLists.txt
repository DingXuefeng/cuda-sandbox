### CMakeLists.txt for CUDA

cmake_minimum_required(VERSION 2.8)

find_package(CUDA REQUIRED)
set(CUDA_NVCC_FLAGS
  "${CUDA_NVCC_FLAGS};-std=c++11;-G;-g;-lineinfo;--compiler-options;-Wall,-Wextra,-Werror=return-type;-gencode;arch=compute_35,code=sm_35;")
SET(CUDA_SEPARABLE_COMPILATION ON)

set_source_files_properties( main.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )
set_source_files_properties( lib1.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )
set_source_files_properties( lib2.cpp PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )

cuda_add_executable(cuda_main main.cc)
target_link_libraries(cuda_main cuda_lib1 cuda_lib2)
cuda_add_library(cuda_lib1 lib1.cc)
target_link_libraries(cuda_lib1 cuda_lib2)
cuda_add_library(cuda_lib2 lib2.cpp)

add_executable(main main.cc)
add_library(lib1 lib1.cc)
add_library(lib2 lib2.cpp)

target_link_libraries(main lib1 lib2)
