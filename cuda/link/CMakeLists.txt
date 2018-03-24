### CMakeLists.txt for CUDA

cmake_minimum_required(VERSION 2.8)
set(CMAKE_MODULE_PATH "/home/xding/sandbox/cuda/link;${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_MODULE_PATH: " ${CMAKE_MODULE_PATH})
find_package(CUDA REQUIRED)
set(CUDA_NVCC_FLAGS
  "${CUDA_NVCC_FLAGS};-std=c++11;-G;-g;-lineinfo;--compiler-options;-Wall,-Wextra,-Werror=return-type;-gencode;arch=compute_35,code=sm_35;")
SET(CUDA_SEPARABLE_COMPILATION ON)

set_source_files_properties( main.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )
set_source_files_properties( lib1.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )
set_source_files_properties( lib2.cc PROPERTIES CUDA_SOURCE_PROPERTY_FORMAT OBJ )

#set(generated_extension ${CMAKE_${CUDA_C_OR_CXX}_OUTPUT_EXTENSION})

set(GPU_ALL_SEPARABLE_COMPILATION_OBJECTS)
macro(my_add_exe cuda_target)
  CUDA_ADD_CUDA_INCLUDE_ONCE()
  CUDA_GET_SOURCES_AND_OPTIONS(sources cmake_options options ${ARGN})
  CUDA_WRAP_SRCS(${cuda_target} OBJ generated_files ${sources} OPTIONS ${options})
  list(APPEND GPU_ALL_SEPARABLE_COMPILATION_OBJECTS
    ${${cuda_target}_SEPARABLE_COMPILATION_OBJECTS})
  message(STATUS "current list: ${GPU_ALL_SEPARABLE_COMPILATION_OBJECTS}")
  add_executable(${cuda_target} ${cmake_options}
    ${generated_files}
    ${sources}
    ${link_file}
    )
  target_link_libraries(${cuda_target} ${CUDA_LINK_LIBRARIES_KEYWORD}
    ${CUDA_LIBRARIES}
    )
  set_target_properties(${cuda_target}
    PROPERTIES
    LINKER_LANGUAGE ${CUDA_C_OR_CXX}
    )
endmacro()

macro(MY_ADD_LIB cuda_target)
  CUDA_ADD_CUDA_INCLUDE_ONCE()

  # Separate the sources from the options
  CUDA_GET_SOURCES_AND_OPTIONS(_sources _cmake_options _options ${ARGN})
  CUDA_BUILD_SHARED_LIBRARY(_cuda_shared_flag ${ARGN})
  # Create custom commands and targets for each file.
  CUDA_WRAP_SRCS( ${cuda_target} OBJ _generated_files ${_sources}
    ${_cmake_options} ${_cuda_shared_flag}
    OPTIONS ${_options} )
  list(APPEND GPU_ALL_SEPARABLE_COMPILATION_OBJECTS
    ${${cuda_target}_SEPARABLE_COMPILATION_OBJECTS})
  message(STATUS "current list: ${GPU_ALL_SEPARABLE_COMPILATION_OBJECTS}")

  # Compute the file name of the intermedate link file used for separable
  # compilation.

  # Add the library.
  add_library(${cuda_target} ${_cmake_options}
    ${_generated_files}
    ${_sources}
    ${link_file}
    )

  if(CUDA_SEPARABLE_COMPILATION)
    target_link_libraries(${cuda_target} ${CUDA_LINK_LIBRARIES_KEYWORD}
      ${CUDA_cudadevrt_LIBRARY}
      )
  endif()

  # We need to set the linker language based on what the expected generated file
  # would be. CUDA_C_OR_CXX is computed based on CUDA_HOST_COMPILATION_CPP.
  set_target_properties(${cuda_target}
    PROPERTIES
    LINKER_LANGUAGE ${CUDA_C_OR_CXX}
    )

endmacro()
macro(generate_cuda_link cuda_target)
  message(STATUS "current list: ${GPU_ALL_SEPARABLE_COMPILATION_OBJECTS}")
  CUDA_COMPUTE_SEPARABLE_COMPILATION_OBJECT_FILE_NAME(link_file ${cuda_target}
    "${GPU_ALL_SEPARABLE_COMPILATION_OBJECTS}")
  CUDA_LINK_SEPARABLE_COMPILATION_OBJECTS("${link_file}" ${cuda_target}
    "${options}" "${GPU_ALL_SEPARABLE_COMPILATION_OBJECTS}")
  add_library(${cuda_target} ${link_file})
endmacro()
#list(APPEND all_SEPARABLE_COMPILATION_OBJECTS ${cuda_main_SEPARABLE_COMPILATION_OBJECTS})
#CUDA_COMPILE(cuda_lib1 lib1.cc)
#set(cuda_all_path "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/cuda_all.dir/${CMAKE_CFG_INTDIR}/cuda_all_intermediate_link${generated_extension}")
#list(APPEND all_SEPARABLE_COMPILATION_OBJECTS ${cuda_lib1_SEPARABLE_COMPILATION_OBJECTS})
#message(STATUS "cuda_lib1_SEPARABLE_COMPILATION_OBJECTS: ${cuda_lib1_SEPARABLE_COMPILATION_OBJECTS}")
#CUDA_COMPILE(cuda_lib2 lib2.cc)
#list(APPEND all_SEPARABLE_COMPILATION_OBJECTS ${cuda_lib2_SEPARABLE_COMPILATION_OBJECTS})
#message(STATUS "cuda_lib2_SEPARABLE_COMPILATION_OBJECTS: ${cuda_lib2_SEPARABLE_COMPILATION_OBJECTS}")
#message(STATUS "CUDA_LINK_SEPARABLE_COMPILATION_OBJECTS(${cuda_all_path} cudaall \"${_options}\"  \"${all_SEPARABLE_COMPILATION_OBJECTS}\")")
#CUDA_LINK_SEPARABLE_COMPILATION_OBJECTS(${cuda_all_path} cuda_all "${_options}"
#  "${all_SEPARABLE_COMPILATION_OBJECTS}")
##target_link_libraries(cuda_main cuda_lib1 cuda_lib2)
#
#add_library(lib1 lib1.cc)
#add_library(lib2 lib2.cc)
#add_executable(main  ${generated_files})
#cuda_add_library(lib1 lib1.cc lib2.cc)
#cuda_add_library(lib2 lib2.cc)
#cuda_add_executable(main  main.cc)
#
my_add_exe(main main.cc)
my_add_lib(lib1 lib1.cc)
my_add_lib(lib2 lib2.cc)
generate_cuda_link(all_gpu)
target_link_libraries(main all_gpu lib1 lib2)
