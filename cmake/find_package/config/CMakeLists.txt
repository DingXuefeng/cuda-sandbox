cmake_minimum_required(VERSION 3.0)
project(Boo VERSION 1.2.3)
add_library(Boo SHARED Boo.cpp)
set_target_properties(Boo PROPERTIES PUBLIC_HEADER "Boo.hpp")



message(STATUS "CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR})

#set(generated_headers "${CMAKE_CURRENT_BINARY_DIR}/generated_headers")
#set(boo_export "${generated_headers}/Boo.hpp")
#include(GenerateExportHeader)
#generate_export_header(Boo EXPORT_FILE_NAME ${boo_export})

include(GNUInstallDirs)
message(STATUS "CMAKE_INSTALL_LIBDIR: " ${CMAKE_INSTALL_LIBDIR})

set(config_install_dir "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

include(CMakePackageConfigHelpers)
write_basic_package_version_file("${version_config}" COMPATIBILITY SameMajorVersion)
configure_package_config_file("cmake/Config.cmake.in" "${project_config}" INSTALL_DESTINATION "${config_install_dir}")
install(TARGETS Boo
  EXPORT "${TARGETS_EXPORT_NAME}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
  PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

install(FILES "${project_config}" "${version_config}" DESTINATION "${config_install_dir}")
install(EXPORT "${TARGETS_EXPORT_NAME}" NAMESPACE "${namespace}" DESTINATION "${config_install_dir}")
