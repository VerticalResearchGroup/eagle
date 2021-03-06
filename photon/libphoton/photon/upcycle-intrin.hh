#pragma once
#include "photon/photon.hh"

// GP vector registers
#define V0 photon::get_emu()->gp_regs[0]
#define V1 photon::get_emu()->gp_regs[1]
#define V2 photon::get_emu()->gp_regs[2]
#define V3 photon::get_emu()->gp_regs[3]
#define V4 photon::get_emu()->gp_regs[4]
#define V5 photon::get_emu()->gp_regs[5]
#define V6 photon::get_emu()->gp_regs[6]
#define V7 photon::get_emu()->gp_regs[7]
#define V8 photon::get_emu()->gp_regs[8]
#define V9 photon::get_emu()->gp_regs[9]
#define V10 photon::get_emu()->gp_regs[10]
#define V11 photon::get_emu()->gp_regs[11]
#define V12 photon::get_emu()->gp_regs[12]
#define V13 photon::get_emu()->gp_regs[13]
#define V14 photon::get_emu()->gp_regs[14]
#define V15 photon::get_emu()->gp_regs[15]
#define V16 photon::get_emu()->gp_regs[16]
#define V17 photon::get_emu()->gp_regs[17]
#define V18 photon::get_emu()->gp_regs[18]
#define V19 photon::get_emu()->gp_regs[19]
#define V20 photon::get_emu()->gp_regs[20]
#define V21 photon::get_emu()->gp_regs[21]
#define V22 photon::get_emu()->gp_regs[22]
#define V23 photon::get_emu()->gp_regs[23]
#define V24 photon::get_emu()->gp_regs[24]
#define V25 photon::get_emu()->gp_regs[25]
#define V26 photon::get_emu()->gp_regs[26]
#define V27 photon::get_emu()->gp_regs[27]
#define V28 photon::get_emu()->gp_regs[28]
#define V29 photon::get_emu()->gp_regs[29]
#define V30 photon::get_emu()->gp_regs[30]
#define V31 photon::get_emu()->gp_regs[31]

// Transpose registers
#define T0 photon::get_emu()->t_regs[0]
#define T1 photon::get_emu()->t_regs[1]
#define T2 photon::get_emu()->t_regs[2]
#define T3 photon::get_emu()->t_regs[3]
#define T4 photon::get_emu()->t_regs[4]
#define T5 photon::get_emu()->t_regs[5]
#define T6 photon::get_emu()->t_regs[6]
#define T7 photon::get_emu()->t_regs[7]
#define T8 photon::get_emu()->t_regs[8]

#define SIMD_SET_MASK(mask) photon::get_emu()->simd_set_mask(mask)

// Vector Binary operations
#define VADD_I8(dst, src1, src2)   photon::get_emu()->vadd_i8(dst, src1, src2)
#define VADDS_I8(dst, src1, src2)  photon::get_emu()->vadds_i8(dst, src1, src2)
#define VADD_U8(dst, src1, src2)   photon::get_emu()->vadd_u8(dst, src1, src2)
#define VADDS_U8(dst, src1, src2)  photon::get_emu()->vadds_u8(dst, src1, src2)
#define VADD_FP16(dst, src1, src2) photon::get_emu()->vadd_fp16(dst, src1, src2)

#define VSUB_I8(dst, src1, src2)   photon::get_emu()->vsub_i8(dst, src1, src2)
#define VSUBS_I8(dst, src1, src2)  photon::get_emu()->vsubs_i8(dst, src1, src2)
#define VSUB_U8(dst, src1, src2)   photon::get_emu()->vsub_u8(dst, src1, src2)
#define VSUBS_U8(dst, src1, src2)  photon::get_emu()->vsubs_u8(dst, src1, src2)
#define VSUB_FP16(dst, src1, src2) photon::get_emu()->vsub_fp16(dst, src1, src2)

#define VMUL_I8(dst, src1, src2)   photon::get_emu()->vmul_i8(dst, src1, src2)
#define VMULS_I8(dst, src1, src2)  photon::get_emu()->vmuls_i8(dst, src1, src2)
#define VMUL_U8(dst, src1, src2)   photon::get_emu()->vmul_u8(dst, src1, src2)
#define VMULS_U8(dst, src1, src2)  photon::get_emu()->vmuls_u8(dst, src1, src2)
#define VMUL_FP16(dst, src1, src2) photon::get_emu()->vmul_fp16(dst, src1, src2)

#define VDIV_I8(dst, src1, src2)   photon::get_emu()->vdiv_i8(dst, src1, src2)
#define VDIVS_I8(dst, src1, src2)  photon::get_emu()->vdivs_i8(dst, src1, src2)
#define VDIV_U8(dst, src1, src2)   photon::get_emu()->vdiv_u8(dst, src1, src2)
#define VDIVS_U8(dst, src1, src2)  photon::get_emu()->vdivs_u8(dst, src1, src2)
#define VDIV_FP16(dst, src1, src2) photon::get_emu()->vdiv_fp16(dst, src1, src2)

// Fused multiply-add
#define VFMA_I8_I32(acc, src1, src2)  photon::get_emu()->vfma_i8_i32(acc, src1, src2)
#define VFMAS_I8_I32(acc, src1, src2) photon::get_emu()->vfmas_i8_i32(acc, src1, src2)
#define VFMA_U8_U32(acc, src1, src2)  photon::get_emu()->vfma_u8_u32(acc, src1, src2)
#define VFMAS_U8_U32(acc, src1, src2) photon::get_emu()->vfmas_u8_u32(acc, src1, src2)
#define VFMA_FP16(acc, src1, src2)    photon::get_emu()->vfma_fp16(acc, src1, src2)

// Unary / activation functions
#define VSIGMOID_I8(reg)   photon::UpcycleEmu::vsigmoid_i8(reg)
#define VSIGMOID_U8(reg)   photon::UpcycleEmu::vsigmoid_u8(reg)
#define VSIGMOID_FP16(reg) photon::UpcycleEmu::vsigmoid_fp16(reg)

#define VTANH_I8(reg)   photon::UpcycleEmu::vtanh_i8(reg)
#define VTANH_U8(reg)   photon::UpcycleEmu::vtanh_u8(reg)
#define VTANH_FP16(reg) photon::UpcycleEmu::vtanh_fp16(reg)

#define VRELU_I8(reg)   photon::UpcycleEmu::vrelu_i8(reg)
#define VRELU_U8(reg)   photon::UpcycleEmu::vrelu_u8(reg)
#define VRELU_FP16(reg) photon::UpcycleEmu::vrelu_fp16(reg)

// Vector load/store operations
#define VLD(addr, reg) photon::get_emu()->vld((uint8_t *)addr, reg)
#define VBC8(addr, reg)
#define VBC16(addr, reg)
#define VBC32(addr, reg)
#define VLD4T(addr, stride)
#define VLD1T(addr, stride)
#define VST(addr, reg) photon::get_emu()->vst((uint8_t *)addr, reg)

// Prefetch core operations
#define PREFETCH1(addr, len)
