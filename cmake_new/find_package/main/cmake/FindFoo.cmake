# FindFoo.cmake
#
# see https://cmake.org/Wiki/CMake:How_To_Find_Libraries#Writing_find_modules
# No matter which mode is used, if the package has been found, a set of variables will be defined:
# 	<NAME>_FOUND
# 	<NAME>_INCLUDE_DIRS or <NAME>_INCLUDES
# 	<NAME>_LIBRARIES or <NAME>_LIBRARIES or <NAME>_LIBS
# 	<NAME>_DEFINITIONS
# All this takes place in the Find<name>.cmake file.
#
# The basic operation of a module should roughly follow this order
# 	1. Use find_package to detect other libraries that the library depends on
# 		The arguments QUIETLY and REQUIRED should be forwarded (e.g. if current package was REQUIRED, the depencency should also be)
# 		Optionally use pkg-config to detect include/library paths (if pkg-config is available)
# 	2. Use find_path and find_library to look for the header and library files, respectively
# 		Paths supplied by pkg-config are used only as hints on where to look
# 		CMake has many other hardcoded locations where it looks, too
# 		Results should be saved in variables <name>_INCLUDE_DIR and <name>_LIBRARY (note: singular, not plural)
# 		Set <name>_INCLUDE_DIRS to <name>_INCLUDE_DIR <dependency1>_INCLUDE_DIRS ...
# 		Set <name>_LIBRARIES to <name>_LIBRARY <dependency1>_LIBRARIES ...
# 		Dependencies use plural forms, the package itself uses the singular forms defined by find_path and find_library
# 	3. Call the find_package_handle_standard_args() macro to set the <name>_FOUND variable and print a success or failure message.

macro(find_foo foo_root)
find_path(FOO_INCLUDE_DIR Foo.hpp
          HINTS ${foo_root})
message(STATUS "found? " ${FOO_INCLUDE_DIR})

find_library(FOO_LIBRARY NAMES Foo
             HINTS ${foo_root})
message(STATUS "found? " ${FOO_LIBRARY})
endmacro()

find_foo(module)

if(NOT FOO_INCLUDE_DIR OR NOT FOO_LIBRARY)
  message(STATUS "Built-in mode")
  include(ExternalProject)
  ExternalProject_Add(Foo
    PREFIX ${PROJECT_SOURCE_DIR}/external/Foo
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/../module
    )
  message(STATUS "bin: " ${CMAKE_BINARY_DIR})
  ExternalProject_Get_Property(Foo install_dir)
  message(STATUS "install: " ${install_dir})
  set(FOO_INCLUDE_DIR ${install_dir}/include)
  set(FOO_LIBRARY ${install_dir}/lib/libFoo.so)
  message(STATUS "include: " ${FOO_INCLUDE_DIR})
  message(STATUS "library: " ${FOO_LIBRARY})
endif()

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LIBXML2_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(Foo DEFAULT_MSG
                                  FOO_INCLUDE_DIR FOO_LIBRARY)

mark_as_advanced(FOO_INCLUDE_DIR FOO_LIBRARY )

set(FOO_LIBRARIES ${FOO_LIBRARY} )
set(FOO_INCLUDE_DIRS ${FOO_INCLUDE_DIR} )
