#pragma once

namespace electron {

enum DataType {
    DT_INT8,
    DT_UINT8,
    DT_FP16
};

static size_t dtype_size(DataType dtype) {
    switch (dtype) {
    case DT_INT8:
    case DT_UINT8:
        return 1;
    case DT_FP16:
        return 2;
    default:
        assert(false);
    }
}


}

