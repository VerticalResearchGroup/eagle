#include "upcycle/upcycle-intrin.hh"
#include "operators/kernel.hh"
#include "operators/elemwise/elemwise-dev.hh"

using namespace electron::operators::device;


KERNEL(add_i8, ElemwiseBinGArgs, ElemwiseLArgs) {
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * src2 = ((char *)g_args->src2) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;

    SIMD_SET_MASK(VLEN_MAX_I8 - 1);

    for (size_t left = l_args->len; left > VLEN_MAX_I8; left -= VLEN_MAX_I8) {
        VLD(src1, V0);
        VLD(src2, V1);
        VADD_I8(V2, V0, V1);
        VST(dst, V2);

        src1 += VLEN_MAX_I8;
        src2 += VLEN_MAX_I8;
        dst += VLEN_MAX_I8;
    }

    SIMD_SET_MASK((1 << left) - 1);

    VLD(src1, V0);
    VLD(src2, V1);
    VADD_I8(V2, V0, V1);
    VST(dst, V2);
}

KERNEL(add_u8, ElemwiseBinGArgs, ElemwiseLArgs) {
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * src2 = ((char *)g_args->src2) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;

    SIMD_SET_MASK(VLEN_MAX_U8 - 1);

    for (size_t left = l_args->len; left > VLEN_MAX_U8; left -= VLEN_MAX_U8) {
        VLD(src1, V0);
        VLD(src2, V1);
        VADD_U8(V2, V0, V1);
        VST(dst, V2);

        src1 += VLEN_MAX_U8;
        src2 += VLEN_MAX_U8;
        dst += VLEN_MAX_U8;
    }

    SIMD_SET_MASK((1 << left) - 1);

    VLD(src1, V0);
    VLD(src2, V1);
    VADD_U8(V2, V0, V1);
    VST(dst, V2);
}

KERNEL(add_fp16, ElemwiseBinGArgs, ElemwiseLArgs) {
    uint16_t * src1 = ((uint16_t *)g_args->src1) + l_args->off;
    uint16_t * src2 = ((uint16_t *)g_args->src2) + l_args->off;
    uint16_t * dst = ((uint16_t *)g_args->dst) + l_args->off;

    SIMD_SET_MASK(VLEN_MAX_FP16 - 1);

    for (size_t left = l_args->len; left > VLEN_MAX_FP16; left -= VLEN_MAX_FP16) {
        VLD(src1, V0);
        VLD(src2, V1);
        VADD_FP16(V2, V0, V1);
        VST(dst, V2);

        src1 += VLEN_MAX_FP16;
        src2 += VLEN_MAX_FP16;
        dst += VLEN_MAX_FP16;
    }

    SIMD_SET_MASK((1 << left) - 1);

    VLD(src1, V0);
    VLD(src2, V1);
    VADD_U8(V2, V0, V1);
    VST(dst, V2);
}

