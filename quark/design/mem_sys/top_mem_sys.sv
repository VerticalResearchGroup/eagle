`include "../com/intf/cache_interfaces.svh"

/* Interface instance naming convention

 <sender>to<recevier>_<req/rsp>_if

 list of sender/receiver prefixes - client side
 prefetch core      = pf
 steele/vector core = vec
 gluon core         = gluon
 TC FSM             = tcfsm

 list of sender/receiver prefixes - mem sys side
 l1_dcache_p        = l1dp
 l1_dcache_splus    = l1ds
 l1_icache_p        = l1ip
 l1_icache_s        = l1is

*/ 

module top_mem_sys (
input clk,
input rst_n,
// Prefetch Core <-> 
//                   l1_dcache_p
coretol1_request.receiver  pftol1dp_req_if,
l1tocore_response.sender   l1dptopf_rsp_if,
//                   l1_icache_p
coretol1_request.receiver  pftol1ip_req_if,
l1tocore_response.sender   l1iptopf_rsp_if,
//                   l1_dacache_splus
prefetch_request.receiver  pftol1ds_req_if,
prefetch_response.sender   l1dstopf_rsp_if,
// Gluon Core <->
//                   l1_dcache_splus
gluontol1_request.receiver gluontol1_req_if,
l1togloun_response.sender  l1togluon_rsp_if,
// Steele Core <-> 
//                   l1_dcache_splus
coretol1_request.receiver vectol1ds_req_if,
l1tocore_response.sender  l1dstovec_rsp_if,
//                   l1_icache_s
coretol1_request.receiver vectol1is_req_if,
l1tocore_response.sender  l1istovec_rsp_if,
// TC FSM <-> MRA
l1tomra_request.receiver  tcfsmtomra_req_if,
mratol1_response.sender   mratotcfsm_rsp_if
);

  l1_cache l1_icache_p(
    .clk(clk),
    .rst_n(rst_n),
    .req(pftol1ip_req_if),
    .rsp(l1iptopf_rsp_if),
    .mem_req(),
    .mem_rsp()
  );

  l1_cache l1_icache_s(
    .clk(clk),
    .rst_n(rst_n),
    .req(vectol1is_req_if),
    .rsp(l1istovec_rsp_if),
    .mem_req(),
    .mem_rsp()
  );

  l1_cache l1_dcache_p(
    .clk(clk),
    .rst_n(rst_n),
    .req(pftol1dp_req_if),
    .rsp(l1dptopf_rsp_if),
    .mem_req(),
    .mem_rsp()
  );

  l1_dcache_splus l1_dsplus(
    .clk(clk),
    .rst_n(rst_n),
    // Prefetch Core <-> l1_dacache_splus
    .pftol1ds_req_if(),
    .l1dstopf_rsp_if(),
    // Gluon Core <-> l1_dcache_splus
    .gluontol1_req_if(),
    .l1togluon_rsp_if(),
    // Steele Core <-> l1_dcache_splus
    .vectol1ds_req_if(),
    .l1dstovec_rsp_if(),
    // Cache <-> MRA
    .l1dsplus_req_if(),
    .l1dsplus_rsp_if(),
    .mem_req(),
    .mem_rsp()
  );

  mem_req_arbiter mra(
    .clk(clk),
    .rst_n(rst_n),
    .tcfsmtomra_req_if(),
    .mratotcfsm_rsp_if(),
    .l1dptomra_req_if(),
    .mratol1dp_rsp_if(),
    .l1iptomra_req_if(),
    .mratol1ip_rsp_if(),
    .l1dstomra_req_if(),
    .mratol1ds_rsp_if(),
    .l1istomra_req_if(),
    .mratol1is_rsp_if(),
    .mratorouter_req_if(),
    .routertomra_rsp_if()
  );

  l2_cache llc(
    .clk(clk),
    .rst_n(rst_n),
    .l2_req(),
    .l2_rsp()
  );

endmodule
