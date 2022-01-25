#pragma once
#include "photon/photon-emu.hh"

// Here we just define the intrinsic operations to allow user code to at least
// compile / report errors.

#define VLEN_MAX_I8 64
#define VLEN_MAX_U8 64
#define VLEN_MAX_FP16 32
#define VLEN_MAX_I32 16
#define VLEN_MAX_U32 16

// GP vector registers
#define V0 photon::UpcycleEmu::singleton().gp_regs[0]
#define V1 photon::UpcycleEmu::singleton().gp_regs[1]
#define V2 photon::UpcycleEmu::singleton().gp_regs[2]
#define V3 photon::UpcycleEmu::singleton().gp_regs[3]
#define V4 photon::UpcycleEmu::singleton().gp_regs[4]
#define V5 photon::UpcycleEmu::singleton().gp_regs[5]
#define V6 photon::UpcycleEmu::singleton().gp_regs[6]
#define V7 photon::UpcycleEmu::singleton().gp_regs[7]
#define V8 photon::UpcycleEmu::singleton().gp_regs[8]
#define V9 photon::UpcycleEmu::singleton().gp_regs[9]
#define V10 photon::UpcycleEmu::singleton().gp_regs[10]
#define V11 photon::UpcycleEmu::singleton().gp_regs[11]
#define V12 photon::UpcycleEmu::singleton().gp_regs[12]
#define V13 photon::UpcycleEmu::singleton().gp_regs[13]
#define V14 photon::UpcycleEmu::singleton().gp_regs[14]
#define V15 photon::UpcycleEmu::singleton().gp_regs[15]
#define V16 photon::UpcycleEmu::singleton().gp_regs[16]
#define V17 photon::UpcycleEmu::singleton().gp_regs[17]
#define V18 photon::UpcycleEmu::singleton().gp_regs[18]
#define V19 photon::UpcycleEmu::singleton().gp_regs[19]
#define V20 photon::UpcycleEmu::singleton().gp_regs[20]
#define V21 photon::UpcycleEmu::singleton().gp_regs[21]
#define V22 photon::UpcycleEmu::singleton().gp_regs[22]
#define V23 photon::UpcycleEmu::singleton().gp_regs[23]
#define V24 photon::UpcycleEmu::singleton().gp_regs[24]
#define V25 photon::UpcycleEmu::singleton().gp_regs[25]
#define V26 photon::UpcycleEmu::singleton().gp_regs[26]
#define V27 photon::UpcycleEmu::singleton().gp_regs[27]
#define V28 photon::UpcycleEmu::singleton().gp_regs[28]
#define V29 photon::UpcycleEmu::singleton().gp_regs[29]
#define V30 photon::UpcycleEmu::singleton().gp_regs[30]
#define V31 photon::UpcycleEmu::singleton().gp_regs[31]

// Transpose registers
#define T0 photon::UpcycleEmu::singleton().gp_regs[0]
#define T1 photon::UpcycleEmu::singleton().gp_regs[1]
#define T2 photon::UpcycleEmu::singleton().gp_regs[2]
#define T3 photon::UpcycleEmu::singleton().gp_regs[3]
#define T4 photon::UpcycleEmu::singleton().gp_regs[4]
#define T5 photon::UpcycleEmu::singleton().gp_regs[5]
#define T6 photon::UpcycleEmu::singleton().gp_regs[6]
#define T7 photon::UpcycleEmu::singleton().gp_regs[7]
#define T8 photon::UpcycleEmu::singleton().gp_regs[8]

#define SIMD_SET_MASK(mask) // TODO

// Vector Binary operations
#define VADD_I8(dst, src1, src2)   photon::UpcycleEmu::vadd_i8(dst, src1, src2)
#define VADDS_I8(dst, src1, src2)  photon::UpcycleEmu::vadds_i8(dst, src1, src2)
#define VADD_U8(dst, src1, src2)   photon::UpcycleEmu::vadd_u8(dst, src1, src2)
#define VADDS_U8(dst, src1, src2)  photon::UpcycleEmu::vadds_u8(dst, src1, src2)
#define VADD_FP16(dst, src1, src2) photon::UpcycleEmu::vadd_fp16(dst, src1, src2)

#define VSUB_I8(dst, src1, src2)   photon::UpcycleEmu::vsub_i8(dst, src1, src2)
#define VSUBS_I8(dst, src1, src2)  photon::UpcycleEmu::vsubs_i8(dst, src1, src2)
#define VSUB_U8(dst, src1, src2)   photon::UpcycleEmu::vsub_u8(dst, src1, src2)
#define VSUBS_U8(dst, src1, src2)  photon::UpcycleEmu::vsubs_u8(dst, src1, src2)
#define VSUB_FP16(dst, src1, src2) photon::UpcycleEmu::vsub_fp16(dst, src1, src2)

#define VMUL_I8(dst, src1, src2)   photon::UpcycleEmu::vmul_i8(dst, src1, src2)
#define VMULS_I8(dst, src1, src2)  photon::UpcycleEmu::vmuls_i8(dst, src1, src2)
#define VMUL_U8(dst, src1, src2)   photon::UpcycleEmu::vmul_u8(dst, src1, src2)
#define VMULS_U8(dst, src1, src2)  photon::UpcycleEmu::vmuls_u8(dst, src1, src2)
#define VMUL_FP16(dst, src1, src2) photon::UpcycleEmu::vmul_fp16(dst, src1, src2)

#define VDIV_I8(dst, src1, src2)   photon::UpcycleEmu::vdiv_i8(dst, src1, src2)
#define VDIVS_I8(dst, src1, src2)  photon::UpcycleEmu::vdivs_i8(dst, src1, src2)
#define VDIV_U8(dst, src1, src2)   photon::UpcycleEmu::vdiv_u8(dst, src1, src2)
#define VDIVS_U8(dst, src1, src2)  photon::UpcycleEmu::vdivs_u8(dst, src1, src2)
#define VDIV_FP16(dst, src1, src2) photon::UpcycleEmu::vdiv_fp16(dst, src1, src2)

// Fused multiply-add
#define VFMA_I8_I32(acc, src1, src2)  photon::UpcycleEmu::vfma_i8_i32(acc, src1, src2)
#define VFMAS_I8_I32(acc, src1, src2) photon::UpcycleEmu::vfmas_i8_i32(acc, src1, src2)
#define VFMA_U8_U32(acc, src1, src2)  photon::UpcycleEmu::vfma_u8_u32(acc, src1, src2)
#define VFMAS_U8_U32(acc, src1, src2) photon::UpcycleEmu::vfmas_u8_u32(acc, src1, src2)
#define VFMA_FP16(acc, src1, src2)    photon::UpcycleEmu::vfma_fp16(acc, src1, src2)

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
#define VLD(addr, reg) photon::UpcycleEmu::vld((uint8_t *)addr, reg)
#define VBC8(addr, reg)
#define VBC16(addr, reg)
#define VBC32(addr, reg)
#define VLD4T(addr, stride)
#define VLD1T(addr, stride)
#define VST(addr, reg) photon::UpcycleEmu::vst((uint8_t *)addr, reg)

// Prefetch core operations
#define PREFETCH1(addr, len)
