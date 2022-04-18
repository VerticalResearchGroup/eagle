cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(add_op_cpu)

find_package(Torch REQUIRED)

# Define our library target
add_library(add_op_cpu SHARED add_op_cpu.cpp)
# Enable C++14
target_compile_features(add_op_cpu PRIVATE cxx_std_14)
# Link against LibTorch
target_link_libraries(add_op_cpu "${TORCH_LIBRARIES}")
