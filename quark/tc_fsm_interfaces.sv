interface sn_tc_if#(
    parameter ADDR_WIDTH = 64,
    parameter WL_LEN_BITS = 32
)();
    logic                     next_op;
    logic    [ADDR_WIDTH-1:0] next_addr;
    logic   [WL_LEN_BITS-1:0] next_len;
    logic                     clr_next;
    logic                     req_done;

// from SN's perspective
modport sn (output next_op, 
            output next_addr, 
            output next_len,
            input clr_next,
            input req_done);

// from TC's perspective
modport tc (input next_op, 
            input next_addr, 
            input next_len,
            output clr_next,
            output req_done);

endinterface:sn_tc_if

interface tc_simd_core_if#(
    parameter ADDR_WIDTH = 64
)();
    logic                     done;
    logic                     reset;
    logic    [ADDR_WIDTH-1:0] g_arg_pointer;
    logic    [ADDR_WIDTH-1:0] l_arg_pointer; 
    logic    [ADDR_WIDTH-1:0] SIMD_pointer;  

// from TC's perspective
modport tc (input done,
            output reset,
            output g_arg_pointer,
            output l_arg_pointer,
            output SIMD_pointer);

// from SIMD Cores's perspective
modport simd (output done,
            input reset,
            input g_arg_pointer,
            input l_arg_pointer,
            input SIMD_pointer);

endinterface:tc_simd_core_if

interface tc_pf_core_if#(
    parameter ADDR_WIDTH = 64
)();
    logic                     done;
    logic                     reset;
    logic    [ADDR_WIDTH-1:0] PF_pointer;  

// from TC's perspective
modport tc (input done,
            output reset,
            output PF_pointer);

// from PF Cores's perspective
modport pf (output done,
            input reset,
            input PF_pointer);

endinterface:tc_pf_core_if