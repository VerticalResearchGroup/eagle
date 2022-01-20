#pragma once

#if !defined(__EMU__) && !defined(__QUARK__)
// Here we just define the intrinsic operations to allow user code to at least
// compile / report errors.

// GP vector registers
#define V0 0
#define V1 1
#define V2 2
#define V3 3
#define V4 4
#define V5 5
#define V6 6
#define V7 7
#define V8 8
#define V9 9
#define V10 10
#define V11 11
#define V12 12
#define V13 13
#define V14 14
#define V15 15
#define V16 16
#define V17 17
#define V18 18
#define V19 19
#define V20 20
#define V21 21
#define V22 22
#define V23 23
#define V24 24
#define V25 25
#define V26 26
#define V27 27
#define V28 28
#define V29 29
#define V30 30
#define V31 31

// Transpose registers
#define T0 0
#define T1 1
#define T2 2
#define T3 3
#define T4 4
#define T5 5
#define T6 6
#define T7 7
#define T8 8

// Vector Binary operations
#define VADD_I8(dst, src1, src2)
#define VADDS_I8(dst, src1, src2)
#define VADD_U8(dst, src1, src2)
#define VADDS_U8(dst, src1, src2)
#define VADD_FP16(dst, src1, src2)

#define VSUB_I8(dst, src1, src2)
#define VSUBS_I8(dst, src1, src2)
#define VSUB_U8(dst, src1, src2)
#define VSUBS_U8(dst, src1, src2)
#define VSUB_FP16(dst, src1, src2)

#define VMUL_I8(dst, src1, src2)
#define VMULS_I8(dst, src1, src2)
#define VMUL_U8(dst, src1, src2)
#define VMULS_U8(dst, src1, src2)
#define VMUL_FP16(dst, src1, src2)

#define VMUL_I8(dst, src1, src2)
#define VMULS_I8(dst, src1, src2)
#define VMUL_U8(dst, src1, src2)
#define VMULS_U8(dst, src1, src2)
#define VMUL_FP16(dst, src1, src2)

// Fused multiply-add
#define VFMA_I8_I32(acc, src1, src2)
#define VFMAS_I8_I32(acc, src1, src2)
#define VFMA_U8_U32(acc, src1, src2)
#define VFMAS_U8_U32(acc, src1, src2)
#define VFMA_FP16(acc, src1, src2)

// Unary / activation functions
#define SIGMOID_I8(reg)
#define SIGMOID_U8(reg)
#define SIGMOID_FP16(reg)

#define TANH_I8(reg)
#define TANH_U8(reg)
#define TANH_FP16(reg)

#define RELU_I8(reg)
#define RELU_U8(reg)
#define RELU_FP16(reg)

// Vector load/store operations
#define VLD(addr, reg)
#define VBC8(addr, reg)
#define VBC16(addr, reg)
#define VBC32(addr, reg)
#define VLD4T(addr, stride)
#define VLD1T(addr, stride)
#define VST(addr, reg)

// Prefetch core operations
#define PREFETCH1(addr, len)

#elif defined(__EMU__) && !defined(__QUARK__)
#include "photon/upcycle-intrin.hh"
#elif !defined(__EMU__) && defined(__QUARK__)
#include "quark/upcycle-intrin.hh"
#else
#error Cannot compile for both EMU and QUARK at the same time

#endif
