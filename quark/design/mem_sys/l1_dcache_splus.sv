module l1_dcache_splus (
input clk,
input rst_n,
// Prefetch Core <-> l1_dacache_splus
prefetch_request.receiver  pftol1ds_req_if,
prefetch_response.sender   l1dstopf_rsp_if,
// Gluon Core <-> l1_dcache_splus
gluontol1_request.receiver gluontol1_req_if,
l1togloun_response.sender  l1togluon_rsp_if,
// Steele Core <-> l1_dcache_splus
coretol1_request.receiver  vectol1ds_req_if,
l1tocore_response.sender   l1dstovec_rsp_if,
// Cache <-> MRA
l1tomra_request.sender     mem_req,
mratol1_response.receiver  mem_rsp
);




endmodule
