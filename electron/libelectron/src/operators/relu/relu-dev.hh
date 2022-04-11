#pragma once
#include "operators/kernel.hh"

namespace electron::operators::device {

struct ReluGArgs {
    void * src1;
    void * dst;
};

struct ReluLArgs {
    size_t off;
    size_t len;
};

}
