//#define OpenCL PrivateUse1
//#define AutogradOpenCL AutogradPrivateUse1
#include <torch/torch.h>
#include <ATen/ATen.h>
#include <c10/core/Storage.h>

using namespace torch;
/*TORCH_LIBRARY(myops, m) {
  m.def("myadd(Tensor self, Tensor other) -> Tensor");
}
*/
TORCH_LIBRARY(eagle, m) {
  m.def("add(Tensor self, Tensor other, Scalar alpha) -> Tensor");
}

/*TORCH_LIBRARY(aten, m) {
  m.def("add(Tensor self, Tensor other, Scalar alpha) -> Tensor");
}
*/

Tensor myadd_cpu(const Tensor& self_, const Tensor& other_) {
  TORCH_CHECK(self_.sizes() == other_.sizes());
  //TORCH_INTERNAL_ASSERT(self_.device().type() == DeviceType::PrivateUse1);
  //TORCH_INTERNAL_ASSERT(other_.device().type() == DeviceType::PrivateUse1);
  Tensor self = self_.contiguous();
  Tensor other = other_.contiguous();
  Tensor result = torch::empty(self.sizes(), self.options());
  const float* self_ptr = self.data_ptr<float>();
  const float* other_ptr = other.data_ptr<float>();
  float* result_ptr = result.data_ptr<float>();
  for (int64_t i = 0; i < result.numel(); i++) {
    result_ptr[i] = self_ptr[i] + other_ptr[i];
  }
  return result;
}

Tensor newadd(const Tensor & self, const Tensor & other, Scalar alpha)//, const Scalar & alpha)//, Tensor & out)
{
  TORCH_CHECK(self.sizes() == other.sizes());
  //TORCH_INTERNAL_ASSERT(self_.device().type() == DeviceType::PrivateUse1);
  //TORCH_INTERNAL_ASSERT(other_.device().type() == DeviceType::PrivateUse1);
  Tensor self_ = self.contiguous();
  Tensor other_ = other.contiguous();
  Tensor result = torch::empty(self_.sizes(), self_.options());
  const float* self_ptr = self_.data_ptr<float>();
  const float* other_ptr = other_.data_ptr<float>();
  float* result_ptr = result.data_ptr<float>();
  float w0 = alpha.toDouble();
  for (int64_t i = 0; i < result.numel(); i++) {
    result_ptr[i] = w0*100000 * self_ptr[i] + other_ptr[i];
  }
  return result;
}

// TODO: memory allocation of tensors
TORCH_LIBRARY_IMPL(eagle, PrivateUse1, m) {
  //m.impl("myadd", TORCH_FN(myadd_cpu));
  m.impl("add", &newadd);
}