cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(torch_plugin)

find_package(Torch REQUIRED)
find_path(EAGLE_INC )
find_library(EAGLE_LIB )

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -g")
# Define our library target
add_library(torch_plugin SHARED 
        src/pointwise_ops.cpp
        src/random_ops.cpp
        src/norm_ops.cpp
        src/utils.cpp
        src/registeration.cpp)
# Enable C++14
target_compile_features(torch_plugin PRIVATE cxx_std_14)
# Link against LibTorch
include_directories(${EAGLE_INC})
target_link_libraries(torch_plugin "${TORCH_LIBRARIES}" ${EAGLE_LIB})