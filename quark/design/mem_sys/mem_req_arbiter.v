module mem_req_arbiter (
input clk,
input rst_n,
// TC FSM <-> MRA
l1tomra_request.receiver      tcfsmtomra_req_if,
mratol1_response.sender       mratotcfsm_rsp_if,
// L1 DCACHE P <-> MRA
l1tomra_request.receiver      l1dptomra_req_if,
mratol1_response.sender       mratol1dp_rsp_if,
// L1 ICACHE P <-> MRA
l1tomra_request.receiver      l1iptomra_req_if,
mratol1_response.sender       mratol1ip_rsp_if,
// L1 DCACHE SPLUS <-> MRA
l1tomra_request.receiver      l1dstomra_req_if,
mratol1_response.sender       mratol1ds_rsp_if,
// L1 ICACHE S <-> MRA
l1tomra_request.receiver      l1istomra_req_if,
mratol1_response.sender       mratol1is_rsp_if,
// MRA <-> DATA ROUTER
mratorouter_request.sender    mratorouter_req_if,
routertomra_response.receiver routertomra_rsp_if
);


endmodule
