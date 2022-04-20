module sn_controller#(
   // PARAMETERS
   parameter ADDR_WIDTH = 64,
   parameter WL_LEN_BITS = 32
)(
   // GLOBAL SIGNALS
   input                            clk,
   input                            rst_n,

   // SN Interface
   sn_tc_if.tc                      sn_if,

   // MRA Controller and WIP Controller Interface
   output logic                     start_dispatch,

   // WIP Controller Interface
   input  done_exe,   

   // MRA Controller Interface
   output logic    [ADDR_WIDTH-1:0] WL_addr,
   output logic   [WL_LEN_BITS-1:0] WL_len
);

   // ** Internal Local Parameters **
   localparam  OP_DP = 1'b1; // dispatch operation
   localparam  OP_NOP = 1'b0; // nop operation

   // ** Internal Control Signals **
   logic       save_WL;
   logic       set_clr_nxt;
   logic       set_req_done;
   logic       reset_SRs;                         

   // ** Infer set/reset Registers ** 
   // SR Register: SN's interface clr_next register
   always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin // async reset register
         sn_if.clr_next <= 1'b0;
      end else if (set_clr_nxt) begin // sync set register
         sn_if.clr_next <= 1'b1;
      end else if (reset_SRs) begin // sync reset register
         sn_if.clr_next <= 1'b0;
      end
   end

   // SR Register: SN's interface req_done register
   always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin // async reset register
         sn_if.req_done <= 1'b0;
      end else if (set_req_done) begin // sync set register
         sn_if.req_done <= 1'b1;
      end else if (reset_SRs) begin // sync reset register
         sn_if.req_done <= 1'b0;
      end
   end

   // ** Infer Worklist State Registers ** 
   // WL State Register: WL Address register
   always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin // async reset register
         WL_addr <= {ADDR_WIDTH{1'b0}};
      end else if (save_WL) begin // enabled register
         WL_addr <= sn_if.next_addr;
      end
   end

   // WL State Register: WL Length register
   always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin // async reset register
         WL_len <= {WL_LEN_BITS{1'b0}};
      end else if (save_WL) begin // enabled register
         WL_len <= sn_if.next_len;
      end
   end

   // **Signal Network Controller FSM**
   // state machine states
   typedef enum logic [1:0] {IDLE, EXE_DP, FINISH_DP} state_t;
   state_t state,nxt_state;

   // infer state flops
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         state <= IDLE;
      else
	      state <= nxt_state;
   end
			
   // state machine combinational logic
   always_comb begin
      // set default values
      save_WL = 1'b0;
      set_clr_nxt = 1'b0;
      set_req_done = 1'b0;
      reset_SRs = 1'b0; 
      start_dispatch = 1'b0;
      nxt_state = IDLE;
		
      case (state)
         EXE_DP: begin
            if(!done_exe)begin
               nxt_state = EXE_DP;
            end else begin
               nxt_state = FINISH_DP;
               set_req_done = 1'b1;
            end
         end
         FINISH_DP: begin
            if(sn_if.next_op == OP_NOP)begin
               nxt_state = IDLE;
               reset_SRs = 1'b1;
            end else begin
               nxt_state = FINISH_DP;
            end
         end
         default: begin // IDLE
            if(sn_if.next_op == OP_DP)begin
               nxt_state = EXE_DP;
               save_WL = 1'b1;
               set_clr_nxt = 1'b1;
               start_dispatch = 1'b1;
            end
         end
      endcase
   end

endmodule
