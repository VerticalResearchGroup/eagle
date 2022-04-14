module l1_cache (
input clk,
input rst_n,
input enable,
coretol1_request.receiver req,
l1tocore_response.sender  rsp,
l1tomra_request.sender    mem_req,
mratol1_response.receiver mem_rsp
); 

endmodule
