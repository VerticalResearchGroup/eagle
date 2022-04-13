module mra_controller#(
   // PARAMETERS
   parameter ADDR_WIDTH = 64,
   parameter WL_LEN_BITS = 32, // mike said to set this to 32
   parameter WI_QUEUE_DEPTH = 20 // picking a random number for now
)(
   // Global Signals
   input                         clk,
   input                         rst_n, // active low reset

   // SN Controller Interface
   input        [ADDR_WIDTH-1:0] WL_addr,
   input       [WL_LEN_BITS-1:0] WL_len,
   input                         start_dispatch,

   // MRA Interface
   output logic [ADDR_WIDTH-1:0] MRA_req_addr,
   output logic                  MRA_rw,
   output logic                  MRA_req_valid,
   input                         MRA_ready,

   // FIFO Interface
   input                         FIFO_rd_en
);

   // Internal Registers
   logic       [WL_LEN_BITS-1:0] QS_pop_remain; 
   logic       [WL_LEN_BITS-1:0] QS_req_remain;

   // Internal Control Signals
   logic                         en_dp_load;
   logic                         dec_req_remain;
   logic                         inc_MRA_req_addr;
   logic                         ok_to_req;
   logic                         dp_req_done;

   // Other Internal Signals
   logic                         ceil_WL_len_div_2;

   assign ceil_WL_len_div_2 = (WL_len+1) >> 1;
   assign ok_to_req = ((QS_pop_remain - QS_req_remain < WI_QUEUE_DEPTH)) ? (1'b1) : (1'b0);
   assign MRA_rw = 1'b0;

   // **Infer Registers**

   // QS_pop_remain register
   always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin // reset register
         QS_pop_remain <= {WL_LEN_BITS{1'b0}};
      end else if (FIFO_rd_en & en_dp_load) begin // enable register
         if(en_dp_load)begin
            QS_pop_remain <= ceil_WL_len_div_2;
         end else begin
            QS_pop_remain <= QS_pop_remain - 1;
         end
      end
   end

   // QS_req_remain register
   always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin // reset register
         QS_req_remain <= {WL_LEN_BITS{1'b0}};
      end else if (dec_req_remain & en_dp_load) begin // enable register
         if(en_dp_load)begin
            QS_req_remain <= ceil_WL_len_div_2;
         end else begin
            QS_req_remain <= QS_req_remain - 1;
         end
      end
   end

   // MRA_req_addr register
   always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin // reset register
         MRA_req_addr <= {WL_LEN_BITS{1'b0}};
      end else if (inc_MRA_req_addr & en_dp_load) begin // enable register
         if(en_dp_load)begin
            MRA_req_addr <= WL_addr;
         end else begin
            MRA_req_addr <= MRA_req_addr - 64;
         end
      end
   end

   // **MRA CONTROLLER FSM**
   // state machine states
	typedef enum logic {IDLE, REQ_WL} state_t;
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
		en_dp_load = 1'b0;
		dec_req_remain = 1'b0;
		MRA_req_valid = 1'b0;
		inc_MRA_req_addr = 1'b0;
		nxt_state = IDLE;
		
		case (state)
			REQ_WL: begin
            if(dp_req_done)begin
               nxt_state = IDLE;
            end else begin // !dp_req_done
               nxt_state = REQ_WL;
               if(ok_to_req & MRA_ready)begin
                  dec_req_remain = 1'b1;
                  MRA_req_valid = 1'b1;
                  inc_MRA_req_addr = 1'b1;
               end
            end
			end
			default: begin // IDLE
            if(start_dispatch)begin
               en_dp_load = 1'b1;
               nxt_state = REQ_WL;
            end else begin
               nxt_state = IDLE;
            end
			end
		endcase
   end
endmodule