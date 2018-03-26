### CMakeLists.txt for CUDA

cmake_minimum_required(VERSION 2.8)
set(CMAKE_MODULE_PATH
  "${CMAKE_SOURCE_DIR}/../../my_modules;${CMAKE_MODULE_PATH}")
include(CUDAsafeAddLibraryAndExe)
message(STATUS "CMAKE_MODULE_PATH: " ${CMAKE_MODULE_PATH})
find_package(CUDA REQUIRED)
set(CUDA_NVCC_FLAGS
  "${CUDA_NVCC_FLAGS};-std=c++11;-G;-g;-lineinfo;--compiler-options;-Wall,-Wextra,-Werror=return-type;-gencode;arch=compute_35,code=sm_35;")
SET(CUDA_SEPARABLE_COMPILATION ON)

set_source_files_properties( main.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )
set_source_files_properties( lib1.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )
set_source_files_properties( lib2.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )

cuda_add_more_executable(main main.cc)
cuda_add_more_library(lib1 lib1.cc)
cuda_add_more_library(lib2 lib2.cc)
cuda_gen_gpu_library(all_gpu)
target_link_libraries(main all_gpu lib1 lib2)
