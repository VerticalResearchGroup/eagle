#pragma once

#include <memory>

#include "electron/backend.hh"

namespace electron {

class Operator {
protected:
    const std::shared_ptr<Backend> backend;

public:
    Operator(const std::shared_ptr<Backend>& _backend) : backend(_backend) {}

    virtual void exec() = 0;

    virtual ~Operator() {}
};

}

