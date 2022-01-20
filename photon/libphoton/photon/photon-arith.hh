#include <immintrin.h>
#include "stdint.h"

namespace photon::arithmetic {
static inline int8_t  add_i8( int8_t a,  int8_t b)  { return a + b; }
static inline int8_t  adds_i8(int8_t a,  int8_t b)  { return a + b; } // TODO
static inline uint8_t add_u8( uint8_t a, uint8_t b) { return a + b; }
static inline uint8_t adds_u8(uint8_t a, uint8_t b) { return a + b; } // TODO
static inline uint16_t add_fp16(uint16_t a, uint16_t b) {
    float af = _cvtsh_ss(a);
    float bf = _cvtsh_ss(b);
    return _cvtss_sh(af + bf, _MM_FROUND_CUR_DIRECTION);
}

static inline int32_t  add_i32( int32_t a,  int32_t b)  { return a + b; }
static inline int32_t  adds_i32(int32_t a,  int32_t b)  { return a + b; } // TODO
static inline uint32_t add_u32( uint32_t a, uint32_t b) { return a + b; }
static inline uint32_t adds_u32(uint32_t a, uint32_t b) { return a + b; } // TODO

static inline int8_t  sub_i8( int8_t a,  int8_t b)  { return a - b; }
static inline int8_t  subs_i8(int8_t a,  int8_t b)  { return a - b; } // TODO
static inline uint8_t sub_u8( uint8_t a, uint8_t b) { return a - b; }
static inline uint8_t subs_u8(uint8_t a, uint8_t b) { return a - b; } // TODO
static inline uint16_t sub_fp16(uint16_t a, uint16_t b) {
    float af = _cvtsh_ss(a);
    float bf = _cvtsh_ss(b);
    return _cvtss_sh(af - bf, _MM_FROUND_CUR_DIRECTION);
}

static inline int8_t  mul_i8( int8_t a,  int8_t b)  { return a * b; }
static inline int8_t  muls_i8(int8_t a,  int8_t b)  { return a * b; } // TODO
static inline uint8_t mul_u8( uint8_t a, uint8_t b) { return a * b; }
static inline uint8_t muls_u8(uint8_t a, uint8_t b) { return a * b; } // TODO
static inline uint16_t mul_fp16(uint16_t a, uint16_t b) {
    float af = _cvtsh_ss(a);
    float bf = _cvtsh_ss(b);
    return _cvtss_sh(af * bf, _MM_FROUND_CUR_DIRECTION);
}

static inline int32_t  mul_i8_i32( int8_t a,  int8_t b)  { return ((int32_t)a) * ((int32_t)b); }
static inline uint32_t  mul_u8_u32(uint8_t a, uint8_t b)  { return ((uint32_t)a) * ((uint32_t)b); }

static inline int8_t  div_i8( int8_t a,  int8_t b)  { return a / b; }
static inline int8_t  divs_i8(int8_t a,  int8_t b)  { return a / b; } // TODO
static inline uint8_t div_u8( uint8_t a, uint8_t b) { return a / b; }
static inline uint8_t divs_u8(uint8_t a, uint8_t b) { return a / b; } // TODO
static inline uint16_t div_fp16(uint16_t a, uint16_t b) {
    float af = _cvtsh_ss(a);
    float bf = _cvtsh_ss(b);
    return _cvtss_sh(af / bf, _MM_FROUND_CUR_DIRECTION);
}

}
