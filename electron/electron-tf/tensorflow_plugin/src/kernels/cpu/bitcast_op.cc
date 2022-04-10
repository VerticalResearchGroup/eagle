#include "tensorflow/c/kernels.h"
#include "tensorflow/c/ops.h"
#include "tensorflow/c/tf_datatype.h"
#include "tensorflow/c/tf_status.h"

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

typedef struct BitcastOp {
  TF_DataType input_data_type;
  TF_DataType output_data_type;
  size_t in_size;
  size_t out_size;
} BitcastOp;

static void* BitcastOp_Create(TF_OpKernelConstruction* ctx) {
  auto* kernel = new BitcastOp;

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

static void BitcastOp_Delete(void* kernel) {
  delete static_cast<BitcastOp*>(kernel);
}

static void BitcastOp_Compute(void* kernel, TF_OpKernelContext* ctx) {
  auto* k = static_cast<BitcastOp*>(kernel);
  int dim_count = 0;

  TF_Tensor* tensor;
  TF_Status* status = TF_NewStatus();
  TF_GetInput(ctx, 0, &tensor, status);
  if (TF_GetCode(status) == TF_OK) {
    dim_count = TF_NumDims(tensor);
    if (!(k->in_size >= k->out_size ||
          (dim_count > 0 &&
           TF_Dim(tensor, dim_count - 1) == k->out_size / k->in_size))) {
      std::ostringstream err;
      err << "Cannot bitcast from " << k->input_data_type << " to "
          << k->output_data_type;
      TF_SetStatus(status, TF_INVALID_ARGUMENT, err.str().c_str());
    }
  }

  if (TF_GetCode(status) == TF_OK) {
    auto* dims = new int64_t[dim_count + 1];
    int new_dim_count = dim_count;
    for (int dim = 0; dim < dim_count; ++dim) {
      dims[dim] = TF_Dim(tensor, dim);
    }
    if (k->out_size < k->in_size) {
      dims[new_dim_count++] = static_cast<int64_t>(k->in_size / k->out_size);
    } else if (k->out_size > k->in_size) {
      --new_dim_count;
    }

    TF_Tensor* output = TF_AllocateTensor(k->output_data_type, dims, 0,
                                          TF_DataTypeSize(k->output_data_type));
    TF_TensorBitcastFrom(tensor, k->output_data_type, output, dims,
                         new_dim_count, status);
    if (TF_GetCode(status) == TF_OK) {
      TF_SetOutput(ctx, 0, output, status);
    }
    delete[] dims;
    TF_DeleteTensor(output);
  }

  if (TF_GetCode(status) != TF_OK) {
    TF_OpKernelContext_Failure(ctx, status);
  }
  TF_DeleteStatus(status);
  TF_DeleteTensor(tensor);
}

void RegisterBitcastOpKernel(const char* device_type) {
  StatusSafePtr status(TF_NewStatus());
  
  auto* builder = TF_NewKernelBuilder("Bitcast", device_type,
                                        &BitcastOp_Create, &BitcastOp_Compute,
                                        &BitcastOp_Delete);

  TF_KernelBuilder_TypeConstraint(builder, "T", TF_FLOAT, status.get());
  if (TF_OK != TF_GetCode(status.get()))
    std::cout << " Error while registering Bitcast kernel with attribute T";

  TF_RegisterKernelBuilder("BitcastOp", builder, status.get());
  if (TF_OK != TF_GetCode(status.get()))
    std::cout << " Error while registering Bitcast kernel";
}
}  // namespace demo_plugin

void RegisterDeviceBitcast(const char* device_type) {
  demo_plugin::RegisterBitcastOpKernel(device_type);
}
