#pragma once
#include <iostream>
#include <memory>


#include "electron/backend.hh"


namespace electron {
std::shared_ptr<Backend> make_backend(const std::string& name);
}
