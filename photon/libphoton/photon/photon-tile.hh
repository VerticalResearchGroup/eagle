#pragma once
#include <memory>
#include <stdio.h>
#include <string.h>
#include "stdint.h"

#include "photon/photon-common.hh"
#include "photon/photon-hooks.hh"
#include "photon/photon-cache.hh"

namespace photon {

struct Vreg {
    uint8_t bytes[64] = { 0 };
};

struct TileEmu {
    using VREG_T = Vreg;

    const size_t tile_id;
    const std::shared_ptr<PhotonHooks> hooks;

    VREG_T gp_regs[32];
    VREG_T t_regs[8];

    TileEmu(size_t _tile_id, std::shared_ptr<PhotonHooks> _hooks) :
        tile_id(_tile_id),
        hooks(_hooks) { }



#define BINARY_OP(name, dt, nelem, op) \
    inline void name(VREG_T& dst, VREG_T& src1, VREG_T& src2) { \
        dt * src1_ ## dt = (dt *)src1.bytes; \
        dt * src2_ ## dt = (dt *)src2.bytes; \
        dt * dst_ ## dt = (dt *)dst.bytes; \
        for (size_t i = 0; i < nelem; i++) \
            (dst_ ## dt)[i] = op((src1_ ## dt)[i], (src2_ ## dt)[i]); \
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
    inline void name(VREG_T& acc, VREG_T& src1, VREG_T& src2) { \
        dt_inp * src1_ ## dt_inp = (dt_inp *)src1.bytes; \
        dt_inp * src2_ ## dt_inp = (dt_inp *)src2.bytes; \
        dt_acc * acc_ ## dt_acc = (dt_acc *)acc.bytes; \
        for (size_t i = 0; i < 16; i++) \
            for (size_t j = i * 4; j < (i + 1) * 4; j++) \
                (acc_ ## dt_acc)[i] = add( \
                    (acc_ ## dt_acc)[i], \
                    mul((src1_ ## dt_inp)[j], (src2_ ## dt_inp)[j])); \
    }

    FMA_8_32_OP(vfma_i8_i32, int32_t, int8_t, arithmetic::add_i32, arithmetic::mul_i8_i32)
    FMA_8_32_OP(vfmas_i8_i32, int32_t, int8_t, arithmetic::adds_i32, arithmetic::mul_i8_i32)
    FMA_8_32_OP(vfma_u8_u32, uint32_t, uint8_t, arithmetic::add_u32, arithmetic::mul_u8_u32)
    FMA_8_32_OP(vfmas_u8_u32, uint32_t, uint8_t, arithmetic::adds_u32, arithmetic::mul_u8_u32)

    inline void vfma_fp16(VREG_T& acc, VREG_T& src1, VREG_T& src2) {
        half * src1_fp16 = (half *)src1.bytes;
        half * src2_fp16 = (half *)src2.bytes;
        half * acc_fp16 = (half *)acc.bytes;
        for (size_t i = 0; i < 32; i++)
            acc_fp16[i] += (src1_fp16[i] * src2_fp16[i]);
    }

#define UNARY_OP(name, dt, nelem, op) \
    inline void name(VREG_T& reg) { \
        dt * reg_ ## dt = (dt *)reg.bytes; \
        for (size_t i = 0; i < nelem; i++) \
            (reg_ ## dt)[i] = op((reg_ ## dt)[i]); \
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

    static inline void vld(uint8_t * addr, VREG_T& dst) {
        assert(64 % BLOCK_SIZE == 0);
        for (size_t i = 0; i < 64; i += BLOCK_SIZE) {
            addr += i;
            uint8_t * cl_addr = Cache::read(addr);
            memcpy(dst.bytes + i, cl_addr, BLOCK_SIZE);
        }
    }

    static inline void vst(uint8_t * addr, VREG_T& dst) {
        memcpy(addr, dst.bytes, 64);
    }

    static inline void prefetch(uint8_t * addr, size_t len) {
        size_t i = 0;
        for (i = len; i > BLOCK_SIZE; i -= BLOCK_SIZE) {
            Cache::fetch(addr);
            addr += BLOCK_SIZE;
        }

        if(i > 0) {
            Cache::fetch(addr);
        }
    }
};

// I hate this but I think we have to do it this way...
extern thread_local TileEmu * temu;

static inline TileEmu * get_emu() {
    assert(temu != nullptr);
    return temu;
}

}
