#pragma once
#include "operators/kernel.hh"

namespace electron::operators::device {

struct ElemwiseUnGArgs {
    void * src1;
    void * dst;
};

struct ElemwiseBinGArgs {
    void * src1;
    void * src2;
    void * dst;
};

struct ElemwiseLArgs {
    size_t off;
    size_t len;
};

}
