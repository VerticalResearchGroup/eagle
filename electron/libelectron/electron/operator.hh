#pragma once

#include <memory>

#include "electron/backend.hh"

namespace electron {

class Operator {
protected:
    const Ptr<Backend> backend;

public:
    Operator(Ptr<Backend> _backend) : backend(_backend) {}

    virtual void exec() = 0;

    virtual ~Operator() {}
};

}

