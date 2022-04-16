#pragma once

#include "upcycle/upcycle-api.hh"
#include "electron/electron.hh"

namespace electron::operators {

class ElemwiseBinOp : public Operator {
protected:
    upcycle::WorkHandle handle;

    void * g_args_blob;
    void * l_argss_blob;

    virtual upcycle::KernelFunc pf_kern(DataType dtype) = 0;
    virtual upcycle::KernelFunc simd_kern(DataType dtype) = 0;

    void setup(Tensor& src1, Tensor& src2, Tensor& dst);

public:
    ElemwiseBinOp(Ptr<Backend> _backend) : Operator(_backend) { }
    virtual void exec();
    virtual ~ElemwiseBinOp() { backend->free_workhandle(handle); }
};

class AddOp : public ElemwiseBinOp {
protected:
    virtual upcycle::KernelFunc pf_kern(DataType dtype) override {
        switch (dtype) {
        case DT_INT8: return backend->getsym("add_i8_simd");
        case DT_UINT8: return backend->getsym("add_u8_simd");
        case DT_FP16: return backend->getsym("add_fp16_simd");
        default: return nullptr;
        }
    }

    virtual upcycle::KernelFunc simd_kern(DataType dtype) override {
        switch (dtype) {
        case DT_INT8: return backend->getsym("elemwise_i8_prefetch");
        case DT_UINT8: return backend->getsym("elemwise_i8_prefetch");
        case DT_FP16: return backend->getsym("elemwise_fp16_prefetch");
        default: return nullptr;
        }
    }

public:
    AddOp(Ptr<Backend> _backend, Tensor& src1, Tensor& src2, Tensor& dst) :
        ElemwiseBinOp(_backend) { setup(src1, src2, dst); }
};

class MulOp : public ElemwiseBinOp {
protected:
    virtual upcycle::KernelFunc pf_kern(DataType dtype) override {
        switch (dtype) {
        case DT_INT8: return backend->getsym("mul_i8_simd");
        case DT_UINT8: return backend->getsym("mul_u8_simd");
        case DT_FP16: return backend->getsym("mul_fp16_simd");
        default: return nullptr;
        }
    }

    virtual upcycle::KernelFunc simd_kern(DataType dtype) override {
        switch (dtype) {
        case DT_INT8: return backend->getsym("elemwise_i8_prefetch");
        case DT_UINT8: return backend->getsym("elemwise_i8_prefetch");
        case DT_FP16: return backend->getsym("elemwise_fp16_prefetch");
        default: return nullptr;
        }
    }

public:
    MulOp(Ptr<Backend> _backend, Tensor& src1, Tensor& src2, Tensor& dst) :
        ElemwiseBinOp(_backend) { setup(src1, src2, dst); }
};

}
