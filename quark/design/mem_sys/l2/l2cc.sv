/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   //Added
   wire c_enable_0;
   wire c_enable_1;
   wire c_comp;
   wire c_write_0;
   wire c_write_1;
   wire m_wr;
   wire m_rd;
   wire [4:0] c_tag_out_0;
   wire [4:0] c_tag_out_1;
   wire [15:0] c_data_out_0;
   wire [15:0] c_data_out_1;
   wire [15:0] m_data_out;
   wire [3:0] m_busy;
   wire [15:0] mem_addr;
   wire [15:0] cache_addr;
   reg [2:0] cache_offset;
   reg [15:0] cache_data_in;
   reg [15:0] m_data_in;
   reg useCache; 
   
   
   //End




   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (c_tag_out_0),
                          .data_out             (c_data_out_0),
                          .hit                  (c_hit_0),
                          .dirty                (c_dirty_0),
                          .valid                (c_valid_0),
                          .err                  (c_err_0),
                          // Inputs
                          .enable               (c_enable_0),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (Addr[15:11]),
                          .index                (Addr[10:3]),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (c_comp),
                          .write                (c_write_0),
                          .valid_in             (1'b1));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (c_tag_out_1),
                          .data_out             (c_data_out_1),
                          .hit                  (c_hit_1),
                          .dirty                (c_dirty_1),
                          .valid                (c_valid_1),
                          .err                  (c_err_1),
                          // Inputs
                          .enable               (c_enable_1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (Addr[15:11]),
                          .index                (Addr[10:3]),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (c_comp),
                          .write                (c_write_1),
                          .valid_in             (1'b1));

   four_bank_mem mem(// Outputs
                     .data_out          (m_data_out),
                     .stall             (m_stall),
                     .busy              (m_busy),
                     .err               (m_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (m_data_in),
                     .wr                (m_wr),
                     .rd                (m_rd));
   
   // your code here
   
   assign DataOut = m_data_in;
   assign err = m_err || c_err_0 || c_err_1;

   parameter IDLE = 4'h0;
   parameter C_READ = 4'h1;
   parameter C_WRITE = 4'h2;
   parameter M_W_0 = 4'h3;
   parameter M_W_1 = 4'h4;
   parameter M_W_2 = 4'h5;
   parameter M_W_3 = 4'h6;
   parameter M_R_0 = 4'h7;
   parameter M_R_1 = 4'h8;
   parameter M_R_2_C_0 = 4'h9;
   parameter M_R_3_C_1 = 4'hA;
   parameter C_W_2 = 4'hB;
   parameter C_W_3 = 4'hC;
   parameter C_WRITE_2 = 4'hD;
   parameter DONE_NO_HIT = 4'hE;
   parameter DONE = 4'hF;
   parameter ERROR = 5'h11;


   wire [3:0] state;
   wire [3:0] nxt_state;
   wire victimIn;

   dff state_dff[3:0](.q(state), .d(nxt_state), .rst(rst), .clk(clk));
   dff victimway(.q(victimOut), .d(victimIn), .rst(rst), .clk(clk));
   dff cacheUseTrack(.q(useCacheOut), .d(useCache), .rst(rst), .clk(clk));

   reg [3:0] r_nxt_state;
   reg r_Done;
   reg r_Stall;
   reg r_CacheHit;

   reg reg_c_enable_0;
   reg reg_c_enable_1;
   reg reg_c_comp;
   reg reg_c_write;
   reg reg_m_wr;
   reg reg_m_rd;

   reg [2:0] mem_offset;
   reg [4:0] m_tag;
   assign mem_addr = {m_tag, Addr[10:3], mem_offset};
   reg reg_victimIn;
   /*
        c_enable
        c_comp
        c_write
        c_valid_in
        Done
        Stall
        CacheHit
        m_wr
        m_rd
   */

   wire c_valid;
   wire c_dirty;
   wire c_hit;
   reg [4:0] new_m_tag;

   assign c_valid = c_valid_0 || c_valid_1;
   assign c_dirty = useCache ? c_dirty_1 : c_dirty_0;
   assign c_hit = (c_hit_0 && c_valid_0) || (c_hit_1 && c_valid_1);

   always @(*)
   begin
           cache_data_in = DataIn;
           m_tag = Addr[15:11];
           mem_offset = 3'b000;
           cache_offset = Addr[2:0];
           reg_victimIn = victimOut;
	   useCache = useCacheOut;
	   m_data_in = (c_hit_0 && c_valid_0) ? ((c_hit_1 && c_valid_1) ? c_data_out_1 : c_data_out_0) :
		   (c_hit_1 && c_valid_1) ? c_data_out_1 :
		   useCache ? c_data_out_1 : c_data_out_0;
	   new_m_tag = (c_hit_0 && c_valid_0) ? ((c_hit_1 && c_valid_1) ? c_tag_out_1 : c_tag_out_0) :
                   (c_hit_1 && c_valid_1) ? c_tag_out_1 :
                   useCache ? c_tag_out_1 : c_tag_out_0;
	   
	   //
	   //	assign tag_out = hit_sel_0 ? (hit_sel_1 ? tag_out_1 : tag_out_0) : hit_sel_1 ? tag_out_1 : real_miss_sel ? tag_out_1 : tag_out_0; 
	   //
	   case(state)
                IDLE:
                begin
                        r_nxt_state = Rd && ~Wr ? C_READ :
                                Wr && ~Rd ? C_WRITE : IDLE;
                        reg_c_enable_0 = 1'b1;
			reg_c_enable_1 = 1'b1;
                        reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;

                        r_Done = 1'b0;
                        r_Stall = 1'b0;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;
                end
                C_READ:
                begin
                        //r_nxt_state = (c_hit_0 && c_valid_0) ||  (c_hit_1 && c_valid_1)  ? IDLE :
                        //        (~c_dirty_0 && (~c_hit_0 || ~c_valid_0)) || (~c_dirty_1 && (~c_hit_1 || ~c_valid_1)) ? M_W_0 :
                        //        (c_dirty_0 && (~c_hit_0 || ~c_valid_0)) || (c_dirty_1 && (~c_hit_1 || ~c_valid_1)) ? M_R_0 : IDLE;
			
			r_nxt_state = c_hit && c_valid  ? IDLE :
                                c_dirty && (~c_hit || ~c_valid) ? M_W_0 :
                                ~c_dirty && (~c_hit || ~c_valid) ? M_R_0 : IDLE;

                        reg_c_enable_0 = 1'b1;
			reg_c_enable_1 = 1'b1;

                        reg_c_comp = 1'b1;
                        reg_c_write = 1'b0;

                        r_Done = (c_hit_0 && c_valid_0) ||  (c_hit_1 && c_valid_1);
                        r_Stall = 1'b1;
                        r_CacheHit = (c_hit_0 && c_valid_0) ||  (c_hit_1 && c_valid_1);
			
 			//r_Done = c_hit && c_valid;
                        //r_Stall = 1'b1;
                        //r_CacheHit = c_hit && c_valid;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;

			reg_victimIn = ~victimOut;

			//useCache = (r_nxt_state == IDLE && (c_hit_1 && c_valid_1))
			//	|| ((r_nxt_state == M_W_0 && (~c_dirty_1 && (~c_hit_1 || ~c_valid_1))) || (r_nxt_state == M_W_0 && c_valid_0 && c_valid_1 && victimOut)) 
			//       || (r_nxt_state == M_R_0 && (c_dirty_1 && (~c_hit_1 || ~c_valid_1)) || (r_nxt_state == M_W_0 && c_valid_0 && c_valid_1 && victimOut));
                	useCache = (c_valid_0 & ~c_valid_1) ? 1'b1 : (~c_valid_0 & c_valid_1) ? 1'b0 : (~c_valid_0 & ~c_valid_1) ? 1'b0 : victimOut;
		end
                C_WRITE:
                begin
                        //r_nxt_state = (c_hit_0 && c_valid_0) || (c_hit_1 && c_valid_1) ? DONE :
			//	((~c_hit_0 || ~c_valid_0) && ~c_dirty_0) || ((~c_hit_1 || ~c_valid_1) && ~c_dirty_1) ? M_R_0 :
                        //       ((~c_hit_0 || ~c_valid_0) && c_dirty_0) || ((~c_hit_1 || ~c_valid_1) && c_dirty_1) ? M_W_0 : IDLE;
			
 			
		        r_nxt_state = c_hit && c_valid ? DONE :
				(~c_hit || ~c_valid) && c_dirty ? M_W_0 :
                                (~c_hit || ~c_valid) && ~c_dirty ? M_R_0 : IDLE;

                        //reg_c_enable_0 = ~useCache;
			//reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;

			reg_c_comp = 1'b1;
                        reg_c_write = 1'b1; //??

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0; //c_hit && c_valid;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;
			
			reg_victimIn = ~victimOut;

			//useCache = (r_nxt_state == DONE && (c_hit_1 && c_valid_1)
                        //        || (r_nxt_state == M_R_0 && ((~c_hit_1 || ~c_valid_1) && ~c_dirty_1)) || (r_nxt_state == M_W_0 && c_valid_0 && c_valid_1 && victimOut))
                        //        || ((r_nxt_state == M_W_0 && ((~c_hit_1 || ~c_valid_1) && c_dirty_1)) || (r_nxt_state == M_W_0 && c_valid_0 && c_valid_1 && victimOut));	
			useCache = (c_valid_0 & ~c_valid_1) ? 1'b1 : (~c_valid_0 & c_valid_1) ? 1'b0 : (~c_valid_0 & ~c_valid_1) ? 1'b0 : victimOut;
		end
                M_W_0:
                begin
                        r_nxt_state = m_stall ? M_W_0 : M_W_1;

                        //reg_c_enable_0 = ~useCache;
			//reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;
                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b1;
                        reg_m_rd = 1'b0;

                        mem_offset = 3'b000;
                        cache_offset = 3'b000;

                        m_tag = new_m_tag;
                end
                M_W_1:
                begin
                        r_nxt_state = m_stall ? M_W_1 : M_W_2;

			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b1;
                        reg_m_rd = 1'b0;

                        mem_offset = 3'b010;
                        cache_offset = 3'b010;

                	m_tag = new_m_tag;
		end
                M_W_2:
                begin
                        r_nxt_state = m_stall ? M_W_2 : M_W_3;

			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;
				
                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b1;
                        reg_m_rd = 1'b0;

        		mem_offset = 3'b100;
                        cache_offset = 3'b100;

                	m_tag = new_m_tag;
		end
                M_W_3:
                begin
                        r_nxt_state = m_stall ? M_W_3 : M_R_0;
			
			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
                        reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b1;
                        reg_m_rd = 1'b0;

                        mem_offset = 3'b110;
                        cache_offset = 3'b110;

                	m_tag = new_m_tag;
		end
                M_R_0:
                begin
                        r_nxt_state = m_stall ? M_R_0 : M_R_1;
			
			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
                        reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b1;

                        mem_offset = 3'b000;
                end
                M_R_1:
                begin
                        r_nxt_state = m_stall ? M_R_1 : M_R_2_C_0;
			
			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
                        reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b0;
			reg_m_rd = 1'b1;

                        mem_offset = 3'b010;
                end
                M_R_2_C_0:
                begin
                        r_nxt_state = m_stall ? M_R_2_C_0 : M_R_3_C_1;
			
			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
                        reg_c_comp = 1'b0;
                        reg_c_write = 1'b1;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b1;

                        mem_offset = 3'b100;
                        cache_offset = 3'b000;

                        cache_data_in = m_data_out;
                end
                M_R_3_C_1:
                begin
                        r_nxt_state = m_stall ? M_R_3_C_1 : C_W_2;
				
			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b0;
                        reg_c_write = 1'b1;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b1;

                        mem_offset = 3'b110;
                        cache_offset = 3'b010;

                        cache_data_in = m_data_out;
                end
                C_W_2:
                begin
                        r_nxt_state = C_W_3;
				
			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
                        reg_c_comp = 1'b0;
                        reg_c_write = 1'b1;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;
			
			reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;

                        cache_offset = 3'b100;

                        cache_data_in = m_data_out;
                end
                C_W_3:
                begin
                        r_nxt_state = ~Rd && Wr ? C_WRITE_2 : DONE_NO_HIT;

                        //reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b0;
                        reg_c_write = 1'b1;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;

                        cache_offset = 3'b110;

                        cache_data_in = m_data_out;
                end
                C_WRITE_2:
                begin
                        r_nxt_state = DONE_NO_HIT;

                        //reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b1;
                        reg_c_write = 1'b1;

                        r_Done = 1'b0;
                        r_Stall = 1'b1;
                        r_CacheHit = 1'b0;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;

			useCache = (c_valid_0 & ~c_valid_1) ? 1'b1 : (~c_valid_0 & c_valid_1) ? 1'b0 : (~c_valid_0 & ~c_valid_1) ? 1'b0 : victimOut;
                end
                DONE_NO_HIT:
                begin
                        //r_nxt_state = IDLE;
                        r_nxt_state = Rd && ~Wr ? C_READ :
                                Wr && ~Rd ? C_WRITE : IDLE;
                        
			//reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;

                        r_Done = 1'b1;
                        r_Stall = 1'b0;
                        r_CacheHit = 1'b0;
                        //r_CacheHit =1'b0;
			reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;
                end
                DONE:
                begin
                        //r_nxt_state = IDLE;
                        r_nxt_state = Rd && ~Wr ? C_READ :
                                Wr && ~Rd ? C_WRITE : IDLE;

                        //reg_c_enable_0 = ~useCache;
                        //reg_c_enable_1 = useCache;
                        reg_c_enable_0 = 1'b1;
                        reg_c_enable_1 = 1'b1;
			reg_c_comp = 1'b0;
                        reg_c_write = 1'b0;

                        r_Done = 1'b1;
                        r_Stall = 1'b0;
                        //r_CacheHit = 1'b0; //c_hit && c_valid;
                        r_CacheHit = 1'b1; //c_hit && c_valid;

                        reg_m_wr = 1'b0;
                        reg_m_rd = 1'b0;
                end
                default:
                begin
                        r_nxt_state = IDLE;
                end
        endcase
   end
        assign Done = r_Done;
        assign Stall = r_Stall;
        assign CacheHit = r_CacheHit;
        assign c_enable_0 = 1'b1;//reg_c_enable_0;
	assign c_enable_1 = 1'b1;//reg_c_enable_1;
        assign c_comp = reg_c_comp;
	wire compUseCashe;
        assign c_write_0 = ((c_hit_0 && c_valid_0) && ~(c_hit_1 && c_valid_1)) ? reg_c_write :
		(~useCache && ~(c_hit_0 && c_valid_0) && ~(c_hit_1 && c_valid_1)) ? reg_c_write : 1'b0; 
	assign c_write_1 = (c_hit_1 && c_valid_1) ? reg_c_write :
		useCache && ~(c_hit_0 && c_valid_0) ? reg_c_write : 1'b0;
        assign m_wr = reg_m_wr;
        assign m_rd = reg_m_rd;
        assign nxt_state = r_nxt_state;
	assign victimIn = reg_victimIn;
                                                             
   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
