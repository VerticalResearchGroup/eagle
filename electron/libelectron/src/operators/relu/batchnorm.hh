#pragma once
#include "operators/kernel.hh"

namespace electron::operators::device {

struct AddGArgs {
    void * src1;
    void * src2;
    void * dst;
};

struct AddLArgs {
    size_t off;
    size_t len;
};

}
