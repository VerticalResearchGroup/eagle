#include "upcycle/upcycle-intrin.hh"
#include "operators/kernel.hh"
#include "operators/elemwise/elemwise-dev.hh"

using namespace electron::operators::device;

PREFETCH(elemwise_i8, ElemwiseBinGArgs, ElemwiseLArgs) {
    char * src1 = ((char *)g_args->src1) + l_args->off;
    char * src2 = ((char *)g_args->src2) + l_args->off;
    char * dst = ((char *)g_args->dst) + l_args->off;

    PREFETCH1(src1, l_args->len);
    PREFETCH1(src2, l_args->len);
    PREFETCH1(dst, l_args->len);
}
