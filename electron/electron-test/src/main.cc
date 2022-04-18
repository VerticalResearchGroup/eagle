#include <iostream>
#include <memory>
#include <sstream>

#include "electron/electron.hh"
#include "electron/op-add.hh"
#include "electron/op-relu.hh"

using namespace electron;


std::string lib_path() {
    const char * egl_tools = getenv("EGL_TOOLS"); // This will barf if EGL_TOOLS not set
    std::stringstream ss;
    ss << egl_tools << "/lib/electron-ops-emu.so";
    return ss.str();
}

int relu_test(std::shared_ptr<electron::Backend> backend) {
    std::cout << "Setup Tensors..." << std::endl;
    electron::Tensor src1(backend, DT_INT8, Tensor::Shape { 2048 });
    electron::Tensor dst(backend, DT_INT8, Tensor::Shape { 2048 });

    int8_t * src1_ptr = (int8_t *)src1.get_dev_ptr();
    int8_t * dst_ptr = (int8_t *)dst.get_dev_ptr();
    

    for (size_t i = 0; i < 2048; i++)
        src1_ptr[i] = 32 -(i % 64);


    auto relu_op = electron::operators::ReluOp(backend, src1, dst);
    relu_op.exec();

    for (size_t i = 0; i < 2048; i++) {
        int8_t expected = 32 - (i % 64) > 0 ? 32 - (i % 64) : 0;

        if (dst_ptr[i] != expected) {
            std::cout << "Mismatch at i = " << i << " (" << (int32_t)dst_ptr[i] << " != " << (int32_t)expected << ")!" << std::endl;
        }
    }

    std::cout << "Relu test passed!" << std::endl;

    return 0;
}


int main() {
    auto backend = electron::make_backend("photon");
    backend->loadlib(lib_path());

    std::cout << "Setup Tensors..." << std::endl;
    electron::Tensor src1(backend, DT_INT8, Tensor::Shape { 2048 });
    electron::Tensor src2(backend, DT_INT8, Tensor::Shape { 2048 });
    electron::Tensor dst(backend, DT_INT8, Tensor::Shape { 2048 });

    int8_t * src1_ptr = (int8_t *)src1.get_dev_ptr();
    int8_t * src2_ptr = (int8_t *)src2.get_dev_ptr();
    int8_t * dst_ptr = (int8_t *)dst.get_dev_ptr();

    for (size_t i = 0; i < 2048; i++) {
        src1_ptr[i] = (i % 32) - 32;
        src2_ptr[i] = (i % 64) - 32;
        dst_ptr[i] = 0;
    }

    auto add_op = electron::operators::AddOp(backend, src1, src2, dst);

    // TODO: tensor.sync_device() (transfer data to device)
    std::cout << "Running Operator..." << std::endl;
    add_op.exec();
    // TODO: tensor.sync_host() (transfer result back to host)

    std::cout << "Checking Output..." << std::endl;
    for (size_t i = 0; i < 2048; i++) {
        int8_t a = (i % 32) - 32;
        int8_t b = (i % 64) - 32;
        int8_t expected = a + b;

        if (dst_ptr[i] != expected) {
            std::cout << "Mismatch at i = " << i << " (" << (int32_t)dst_ptr[i] << " != " << (int32_t)expected << ")!" << std::endl;
        }
    }

    relu_test(backend);

    std::cout << "Done!" << std::endl;
    return 0;
}
