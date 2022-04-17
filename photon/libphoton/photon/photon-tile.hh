#pragma once
#include <memory>
#include <stdio.h>
#include <string.h>
#include "stdint.h"

#include "photon/photon-common.hh"
#include "photon/photon-hooks.hh"

namespace photon {

struct Vreg {
    uint8_t bytes[64] = { 0 };
};

struct TileEmu {
    const size_t tile_id;
    const std::shared_ptr<PhotonHooks> hooks;

    Vreg gp_regs[32];
    Vreg t_regs[8];
    uint64_t vmask = 0xffff'ffff'ffff'ffffULL;

    TileEmu(size_t _tile_id, std::shared_ptr<PhotonHooks> _hooks) :
        tile_id(_tile_id),
        hooks(_hooks) { }

#define BINARY_OP(name, dt, nelem, op) \
    inline void name(Vreg& dst, Vreg& src1, Vreg& src2) { \
        dt * src1_ ## dt = (dt *)src1.bytes; \
        dt * src2_ ## dt = (dt *)src2.bytes; \
        dt * dst_ ## dt = (dt *)dst.bytes; \
        for (size_t i = 0; i < nelem; i++) \
            if (vmask & (1 << i)) { \
                (dst_ ## dt)[i] = op((src1_ ## dt)[i], (src2_ ## dt)[i]); \
            } \
    }

    BINARY_OP(vadd_i8,  int8_t,  64, arithmetic::add_i8)
    BINARY_OP(vadds_i8, int8_t,  64, arithmetic::adds_i8)
    BINARY_OP(vadd_u8,  uint8_t, 64, arithmetic::add_u8)
    BINARY_OP(vadds_u8, uint8_t, 64, arithmetic::adds_u8)
    BINARY_OP(vadd_fp16, half, 32, arithmetic::add_fp16)

    BINARY_OP(vsub_i8,  int8_t,  64, arithmetic::sub_i8)
    BINARY_OP(vsubs_i8, int8_t,  64, arithmetic::subs_i8)
    BINARY_OP(vsub_u8,  uint8_t, 64, arithmetic::sub_u8)
    BINARY_OP(vsubs_u8, uint8_t, 64, arithmetic::subs_u8)
    BINARY_OP(vsub_fp16, half, 32, arithmetic::sub_fp16)

    BINARY_OP(vmul_i8,  int8_t,  64, arithmetic::mul_i8)
    BINARY_OP(vmuls_i8, int8_t,  64, arithmetic::muls_i8)
    BINARY_OP(vmul_u8,  uint8_t, 64, arithmetic::mul_u8)
    BINARY_OP(vmuls_u8, uint8_t, 64, arithmetic::muls_u8)
    BINARY_OP(vmul_fp16, half, 32, arithmetic::mul_fp16)

    BINARY_OP(vdiv_i8,  int8_t,  64, arithmetic::div_i8)
    BINARY_OP(vdivs_i8, int8_t,  64, arithmetic::divs_i8)
    BINARY_OP(vdiv_u8,  uint8_t, 64, arithmetic::div_u8)
    BINARY_OP(vdivs_u8, uint8_t, 64, arithmetic::divs_u8)
    BINARY_OP(vdiv_fp16, half, 32, arithmetic::div_fp16)

#define FMA_8_32_OP(name, dt_acc, dt_inp, add, mul) \
    inline void name(Vreg& acc, Vreg& src1, Vreg& src2) { \
        dt_inp * src1_ ## dt_inp = (dt_inp *)src1.bytes; \
        dt_inp * src2_ ## dt_inp = (dt_inp *)src2.bytes; \
        dt_acc * acc_ ## dt_acc = (dt_acc *)acc.bytes; \
        for (size_t i = 0; i < 16; i++) \
            if (vmask & (1 << i)) \
                for (size_t j = i * 4; j < (i + 1) * 4; j++) \
                    (acc_ ## dt_acc)[i] = add( \
                        (acc_ ## dt_acc)[i], \
                        mul((src1_ ## dt_inp)[j], (src2_ ## dt_inp)[j])); \
    }

    FMA_8_32_OP(vfma_i8_i32, int32_t, int8_t, arithmetic::add_i32, arithmetic::mul_i8_i32)
    FMA_8_32_OP(vfmas_i8_i32, int32_t, int8_t, arithmetic::adds_i32, arithmetic::mul_i8_i32)
    FMA_8_32_OP(vfma_u8_u32, uint32_t, uint8_t, arithmetic::add_u32, arithmetic::mul_u8_u32)
    FMA_8_32_OP(vfmas_u8_u32, uint32_t, uint8_t, arithmetic::adds_u32, arithmetic::mul_u8_u32)

    inline void vfma_fp16(Vreg& acc, Vreg& src1, Vreg& src2) {
        half * src1_fp16 = (half *)src1.bytes;
        half * src2_fp16 = (half *)src2.bytes;
        half * acc_fp16 = (half *)acc.bytes;
        for (size_t i = 0; i < 32; i++)
            if (vmask & (1 << i)) acc_fp16[i] += (src1_fp16[i] * src2_fp16[i]);
    }

#define UNARY_OP(name, dt, nelem, op) \
    inline void name(Vreg& reg) { \
        dt * reg_ ## dt = (dt *)reg.bytes; \
        for (size_t i = 0; i < nelem; i++) \
            if (vmask & (1 << i)) (reg_ ## dt)[i] = op((reg_ ## dt)[i]); \
    }

    UNARY_OP(vrelu_i8,  int8_t,  64, arithmetic::relu_i8)
    UNARY_OP(vrelu_u8,  uint8_t, 64, arithmetic::relu_u8)
    UNARY_OP(vrelu_fp16, half, 32, arithmetic::relu_fp16)

    UNARY_OP(vtanh_i8,  int8_t,  64, arithmetic::tanh_i8)
    UNARY_OP(vtanh_u8,  uint8_t, 64, arithmetic::tanh_u8)
    UNARY_OP(vtanh_fp16, half, 32, arithmetic::tanh_fp16)

    UNARY_OP(vsigmoid_i8,  int8_t,  64, arithmetic::sigmoid_i8)
    UNARY_OP(vsigmoid_u8,  uint8_t, 64, arithmetic::sigmoid_u8)
    UNARY_OP(vsigmoid_fp16, half, 32, arithmetic::sigmoid_fp16)

    inline void vld(uint8_t * addr, Vreg& dst) {
        hooks->on_mem_read(tile_id, (uintptr_t)addr);
        for (size_t i = 0; i < 64; i++) {
            if (vmask & (1 << i)) dst.bytes[i] = addr[i];
        }
    }

    inline void vst(uint8_t * addr, Vreg& dst) {
        for (size_t i = 0; i < 64; i++) {
            if (vmask & (1 << i)) addr[i] = dst.bytes[i];
        }
    }

    void simd_set_mask(uint64_t _vmask) { vmask = _vmask; }
};

// I hate this but I think we have to do it this way...
extern thread_local TileEmu * temu;

static inline TileEmu * get_emu() {
    assert(temu != nullptr);
    return temu;
}

}
