#include "upcycle/upcycle-intrin.hh"
#include "operators/kernel.hh"
#include "operators/relu/relu-dev.hh"

using namespace electron::operators::device;

PREFETCH(relu_i8, ReluGArgs, ReluLArgs) {
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;

    PREFETCH1(src1, l_args->len);
    PREFETCH1(dst, l_args->len);
}

KERNEL(relu_i8, ReluGArgs, ReluLArgs) {
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;
    size_t left;

    SIMD_SET_MASK((1 << VLEN_MAX_I8) - 1);

    for (left = l_args->len; left > VLEN_MAX_I8; left -= VLEN_MAX_I8) {
        VLD(src1, V0);
        RELU_I8(V0);
        VST(dst, V0);

        src1 += VLEN_MAX_I8;
        dst += VLEN_MAX_I8;
    }
    SIMD_SET_MASK((1 << left) - 1);

    VLD(src1, V0);
    RELU_I8(V0);
    VST(dst, V0);
}