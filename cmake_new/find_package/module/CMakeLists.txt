cmake_minimum_required(VERSION 3.0)

add_library(Foo SHARED Foo.cpp)

set_target_properties(Foo PROPERTIES PUBLIC_HEADER "Foo.hpp")
INSTALL(TARGETS Foo
        LIBRARY DESTINATION lib
        PUBLIC_HEADER DESTINATION include
)
