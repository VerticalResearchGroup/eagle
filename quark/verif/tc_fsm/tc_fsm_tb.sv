module tc_fsm_tb();

    localparam ADDR_WIDTH = 64;
    localparam DATA_WIDTH = 512;
    localparam WL_LEN_BITS = 32;

    // GLOBAL SIGNALS
    logic                        clk;
    logic                        rst_n;

    // MRA INTERFACE
    l1tomra_request #(.DATA_WIDTH(DATA_WIDTH),
                      .ADDR_WIDTH(ADDR_WIDTH))        
                      mra_req_if(.clk(clk), .rst_n(rst_n));

    mratol1_response #(.DATA_WIDTH(DATA_WIDTH))    
                       mra_rsp_if(.clk(clk), .rst_n(rst_n));

    // PF_CORE INTERFACE
    tc_pf_core_if #(.ADDR_WIDTH(ADDR_WIDTH))            
                    pf_if();
 
    // SIMD_CORE INTERFACE
    tc_simd_core_if #(.ADDR_WIDTH(ADDR_WIDTH))           
                      simd_if();

    // SIGNAL NETWORK INTERFACE
    sn_tc_if #(.ADDR_WIDTH(ADDR_WIDTH), 
               .WL_LEN_BITS(WL_LEN_BITS))
               sn_if();

    tc_fsm tc_fsm(.clk(clk),
                  .rst_n(rst_n),
                  .mra_req_if(mra_req_if.sender),
                  .mra_rsp_if(mra_rsp_if.receiver),
                  .pf_if(pf_if.tc),
                  .simd_if(simd_if.tc),
                  .sn_if(sn_if.tc)
                 );

    // including this to figure out what is needed for the fifo
    

endmodule
