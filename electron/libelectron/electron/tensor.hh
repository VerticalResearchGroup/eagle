#pragma once

#include <vector>
#include <memory>

#include "electron/common.hh"
#include "electron/backend.hh"

namespace electron {

class Tensor {
public:
    using Shape = std::vector<size_t>;

private:
    const std::shared_ptr<Backend> backend;
    const DataType dtype;
    void * dev_ptr;
    std::vector<size_t> shape;

public:
    Tensor(
        const std::shared_ptr<Backend>& _backend,
        const DataType _dtype,
        const Shape& _shape) :
        backend(_backend),
        dtype(_dtype),
        dev_ptr(backend->dev_malloc(dtype_size(_dtype) * num_elem(_shape))),
        shape(_shape) {}

    static size_t num_elem(const Shape& shape) {
        size_t prod = 1;
        for (size_t s : shape) {
            prod *= s;
        }
        return prod;
    }

    size_t num_elem() const { return num_elem(shape); }

    void * get_dev_ptr() { return dev_ptr; }
    std::vector<size_t>& get_shape() { return shape; }
    const std::vector<size_t>& get_shape() const { return shape; }
    const DataType get_dtype() const { return dtype; }


    // TODO: add sync_host/sync_device routines

    ~Tensor() {
        backend->dev_free(dev_ptr);
    }
};

}
