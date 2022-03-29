#include <immintrin.h>
#include <assert.h>
#include <stdint.h>
#include "photon/half.hh"

using half_float::half;
using half_float::half_cast;

namespace photon::arithmetic {

static inline int8_t add_i8(int8_t a,  int8_t b)  { return a + b; }
static inline int8_t adds_i8(int8_t a,  int8_t b)  { int16_t c = (int32_t)a + (int32_t)b; 
                                                      return (c > INT8_MAX) ? INT8_MAX :
                                                             ((c < INT8_MIN) ? INT8_MIN : (int8_t)c);
                                                    }
static inline uint8_t add_u8(uint8_t a, uint8_t b) { return a + b; }
static inline uint8_t adds_u8(uint8_t a, uint8_t b) { uint32_t c = (uint32_t)a + (uint32_t)b; 
                                                      return (c > UINT8_MAX) ? UINT8_MAX : (uint8_t)c;
                                                    }
static inline half add_fp16(half a, half b) { return a + b;}

static inline int32_t add_i32(int32_t a,  int32_t b)  { return a + b; }
static inline int32_t adds_i32(int32_t a,  int32_t b)  { int64_t c = (int64_t)a + (int64_t)b; 
                                                          return (c > INT32_MAX) ? INT32_MAX :
                                                                 ((c < INT32_MIN) ? INT32_MIN : (int32_t)c);
                                                        }
static inline uint32_t add_u32(uint32_t a, uint32_t b) { return a + b; }
static inline uint32_t adds_u32(uint32_t a, uint32_t b) { uint64_t c = (uint64_t)a + (uint64_t)b; 
                                                          return (c > UINT32_MAX) ? UINT32_MAX : (uint32_t)c;
                                                        }

static inline int8_t sub_i8(int8_t a,  int8_t b)  { return a - b; }
static inline int8_t subs_i8(int8_t a,  int8_t b)  { int32_t c = (int32_t)a - (int32_t)b; 
                                                      return (c > INT8_MAX) ? INT8_MAX :
                                                             ((c < INT8_MIN) ? INT8_MIN : (int8_t)c);
                                                    }
static inline uint8_t sub_u8(uint8_t a, uint8_t b) { return a - b; }
static inline uint8_t subs_u8(uint8_t a, uint8_t b) { uint32_t c = (uint32_t)a - (uint32_t)b; 
                                                      return (c > UINT8_MAX) ? UINT8_MAX : (uint8_t)c;
                                                    }
static inline half sub_fp16(half a, half b) { return a - b; }

static inline int8_t mul_i8( int8_t a,  int8_t b)  { return a * b; }
static inline int8_t muls_i8(int8_t a,  int8_t b)  { int32_t c = (int32_t)a * (int32_t)b; 
                                                      return (c > INT8_MAX) ? INT8_MAX :
                                                             ((c < INT8_MIN) ? INT8_MIN : (int8_t)c);
                                                    }
static inline uint8_t mul_u8(uint8_t a, uint8_t b) { return a * b; }
static inline uint8_t muls_u8(uint8_t a, uint8_t b) { uint32_t c = (uint32_t)a * (uint32_t)b; 
                                                      return (c > UINT8_MAX) ? UINT8_MAX : (uint8_t)c;
                                                    }
static inline half mul_fp16(half a, half b) { return a * b; }

static inline int32_t mul_i8_i32(int8_t a,  int8_t b)  { int32_t c = a * b; return c;}
static inline uint32_t mul_u8_u32(uint8_t a, uint8_t b)  { uint32_t c = a * b; return c; }

static inline int8_t div_i8(int8_t a,  int8_t b)  { assert(b != 0); return a / b; }
static inline int8_t divs_i8(int8_t a,  int8_t b)  { assert(b != 0);
                                                      int32_t c = (int32_t)a / (int32_t)b; 
                                                      return (c > INT8_MAX) ? INT8_MAX :
                                                             ((c < INT8_MIN) ? INT8_MIN : (int8_t)c);
                                                    }
static inline uint8_t div_u8(uint8_t a, uint8_t b) { assert(b != 0); return a / b; }
static inline uint8_t divs_u8(uint8_t a, uint8_t b) { assert(b != 0); 
                                                      uint32_t c = (uint32_t)a / (uint32_t)b; 
                                                      return (c > UINT8_MAX) ? UINT8_MAX : (uint8_t)c;
                                                    }
static inline half div_fp16(half a, half b) { assert(b != 0); return a / b; }

static inline int8_t sigmoid_i8(int8_t a) { return 1/(1 + exp(-a)); }
static inline uint8_t sigmoid_u8(uint8_t a) { return 1/(1 + exp(-a)); }
static inline half sigmoid_fp16(half a) { return half_cast<half>(1/(1 + exp(-a))); }

static inline int8_t tanh_i8(int8_t a) { return half_float::tanh(half_cast<half>(a)); }
static inline uint8_t tanh_u8(uint8_t a) { return half_float::tanh(half_cast<half>(a)); }
static inline half tanh_fp16(half a) { return half_float::tanh(a); }

static inline int8_t relu_i8(int8_t a) { return (a > 0) ? a : 0; }
static inline uint8_t relu_u8(uint8_t a) { return (a > 0) ? a : 0; }
static inline half relu_fp16(half a) { return half_cast<half>((a > 0) ? a : 0); }

}