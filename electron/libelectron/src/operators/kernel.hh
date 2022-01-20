#pragma once

#include <stdint.h>


#define PREFETCH(name, g_arg_ty, l_arg_ty) \
    extern "C" void name ## _prefetch(g_arg_ty * g_args, l_arg_ty * l_args)

#define KERNEL(name, g_arg_ty, l_arg_ty) \
    extern "C" void name ## _simd(g_arg_ty * g_args, l_arg_ty * l_args)
