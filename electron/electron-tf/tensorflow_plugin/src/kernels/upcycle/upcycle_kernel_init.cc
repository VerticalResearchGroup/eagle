#include "tensorflow_plugin/src/kernels/upcycle/upcycle_kernel_init.h"
#include "tensorflow/c/kernels.h"

void RegisterDeviceKernels(const char* device_type) {
  RegisterDeviceRelu(device_type);
  RegisterDeviceAdd(device_type);
  RegisterDeviceRelu(device_type);

}
