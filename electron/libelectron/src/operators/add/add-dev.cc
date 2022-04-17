#include "upcycle/upcycle-intrin.hh"
#include "operators/kernel.hh"
#include "operators/add/add-dev.hh"

using namespace electron::operators::device;

PREFETCH(add_i8, AddGArgs, AddLArgs) {
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * src2 = ((char *)g_args->src2) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;

    PREFETCH1(src1, l_args->len);
    PREFETCH1(src2, l_args->len);
    PREFETCH1(dst, l_args->len);
}

KERNEL(add_i8, AddGArgs, AddLArgs) {
    size_t left;
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * src2 = ((char *)g_args->src2) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;

    SIMD_SET_MASK(VMASK_ENABLE_ALL);

    for (left = l_args->len; left >= VLEN_MAX_I8; left -= VLEN_MAX_I8) {
        VLD(src1, V0);
        VLD(src2, V1);
        VADD_I8(V2, V0, V1);
        VST(dst, V2);

        src1 += VLEN_MAX_I8;
        src2 += VLEN_MAX_I8;
        dst += VLEN_MAX_I8;
    }

    if (left > 0) {
        SIMD_SET_MASK(((uint64_t)1 << left) - (uint64_t)1);
        VLD(src1, V0);
        VLD(src2, V1);
        VADD_I8(V2, V0, V1);
        VST(dst, V2);
    }
}

KERNEL(add_u8, AddGArgs, AddLArgs) {
    size_t left;
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * src2 = ((char *)g_args->src2) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;

    SIMD_SET_MASK(VMASK_ENABLE_ALL);

    for (left = l_args->len; left >= VLEN_MAX_U8; left -= VLEN_MAX_U8) {
        VLD(src1, V0);
        VLD(src2, V1);
        VADD_U8(V2, V0, V1);
        VST(dst, V2);

        src1 += VLEN_MAX_U8;
        src2 += VLEN_MAX_U8;
        dst += VLEN_MAX_U8;
    }

    if (left > 0) {
        SIMD_SET_MASK(((uint64_t)1 << left) - (uint64_t)1);
        VLD(src1, V0);
        VLD(src2, V1);
        VADD_U8(V2, V0, V1);
        VST(dst, V2);
    }
}

