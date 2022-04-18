#include "torch/script.h"



torch::Tensor add(torch::Tensor a, torch::Tensor b) {

  torch::Tensor output(a);  
  for (int i = 0 ; i < a.size(0); i++) {
    for(int j = 0; j < a.size(1); j++) {
        output[i] = a[i] + b[i];
    }
  }

  return output.clone();
  // END output_tensor
}


TORCH_LIBRARY(my_ops, m) {
  m.def("warp_perspective", add);
}