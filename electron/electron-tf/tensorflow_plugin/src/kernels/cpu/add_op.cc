#include "tensorflow/c/kernels.h"
#include "tensorflow/c/ops.h"
#include "tensorflow/c/tf_tensor.h"
#include "tensorflow/c/tf_datatype.h"
#include "tensorflow/c/tf_status.h"
#include "absl/container/inlined_vector.h"

#include <sstream>
#include <iostream>
#include <memory>
#include <vector>

namespace demo_plugin {

struct StatusDeleter {
  void operator()(TF_Status* s) {
    if (s != nullptr) {
      TF_DeleteStatus(s);
    }
  }
};

struct TensorDeleter {
  void operator()(TF_Tensor* t) {
    if (t != nullptr) {
      TF_DeleteTensor(t);
    }
  }
};

using StatusSafePtr = std::unique_ptr<TF_Status, StatusDeleter>;
using TensorSafePtr = std::unique_ptr<TF_Tensor, TensorDeleter>;

typedef struct AddOp {
  TF_DataType input_data_type;
  TF_DataType output_data_type;
  size_t in_size;
  size_t out_size;
} AddOp;

static void* AddOp_Create(TF_OpKernelConstruction* ctx) {
  
  auto* kernel = new AddOp;

  TF_Status* s = TF_NewStatus();
  TF_OpKernelConstruction_GetAttrType(ctx, "T", &kernel->input_data_type, s);

  if (TF_GetCode(s) == TF_OK) {
    TF_OpKernelConstruction_GetAttrType(ctx, "type", &kernel->output_data_type,
                                        s);
  }

  if (TF_GetCode(s) == TF_OK) {
    kernel->in_size = TF_DataTypeSize(kernel->input_data_type);
    kernel->out_size = TF_DataTypeSize(kernel->output_data_type);

    size_t check_size = std::max(kernel->in_size, kernel->out_size) %
                        std::min(kernel->in_size, kernel->out_size);
    if (check_size != 0) {
      std::ostringstream err;
      err << "cannot convert between datatype " << kernel->input_data_type
          << " and " << kernel->output_data_type;
      TF_SetStatus(s, TF_INVALID_ARGUMENT, err.str().c_str());
    }
  }

  if (TF_GetCode(s) != TF_OK) {
    TF_OpKernelConstruction_Failure(ctx, s);
    delete kernel;
    kernel = nullptr;
  }

  TF_DeleteStatus(s);
  return kernel;
}

static void AddOp_Delete(void* kernel) {
  delete static_cast<AddOp*>(kernel);
}


template <typename T>
void AddOp_Compute(void* kernel, TF_OpKernelContext* ctx) {

  StatusSafePtr status(TF_NewStatus());
  TF_Tensor* input0 = nullptr;
  TF_Tensor* input1 = nullptr;
  TF_GetInput(ctx, 0, &input0, status.get());
  TF_GetInput(ctx, 1, &input1, status.get());

  TensorSafePtr input_safe_ptr0(input0);
  TensorSafePtr input_safe_ptr1(input1);

  if (TF_GetCode(status.get()) != TF_OK) {
    TF_OpKernelContext_Failure(ctx, status.get());
    return;
  }
  if (TF_TensorElementCount(input_safe_ptr0.get()) == 0) return;
  absl::InlinedVector<int64_t, 4> dims(TF_NumDims(input_safe_ptr0.get()));
  for (auto i = 0; i < TF_NumDims(input_safe_ptr0.get()); ++i) {
    dims[i] = TF_Dim(input_safe_ptr0.get(), i);
  }

  TensorSafePtr output_safe_ptr(TF_AllocateOutput(
      ctx, 0, TF_ExpectedOutputDataType(ctx, 0), dims.data(), dims.size(),
      TF_TensorElementCount(input_safe_ptr0.get()) * sizeof(T), status.get()));
  if (TF_GetCode(status.get()) != TF_OK) {
    TF_OpKernelContext_Failure(ctx, status.get());
    return;
  }

  auto input_ptr0 = static_cast<T*>(TF_TensorData(input_safe_ptr0.get()));
  auto input_ptr1 = static_cast<T*>(TF_TensorData(input_safe_ptr1.get()));

  auto output_ptr = static_cast<T*>(TF_TensorData(output_safe_ptr.get()));
  for (auto i = 0; i < TF_TensorElementCount(input_safe_ptr0.get()); ++i) {
    output_ptr[i] = input_ptr0[i] + input_ptr1[i];
  }
}

template <typename T>
void RegisterAddOpKernel(const char* device_type) {
  StatusSafePtr status(TF_NewStatus());
  auto* builder = TF_NewKernelBuilder("Add", device_type, &AddOp_Create,
                                      &AddOp_Compute<T>, &AddOp_Delete);

  TF_KernelBuilder_TypeConstraint(builder, "T", TF_FLOAT, status.get());
  if (TF_OK != TF_GetCode(status.get()))
    std::cout << " Error while registering relu kernel with attribute T";
  TF_RegisterKernelBuilder("AddOp", builder, status.get());
  if (TF_OK != TF_GetCode(status.get()))
    std::cout << " Error while registering relu kernel";
}

}  // namespace demo_plugin

void RegisterDeviceAdd(const char* device_type) {
  demo_plugin::RegisterAddOpKernel<float>(device_type);
}
