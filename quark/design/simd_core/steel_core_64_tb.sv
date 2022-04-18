//////////////////////////////////////////////////////////////////////////////////
// Engineer: Rafael de Oliveira Calçada (rafaelcalcada@gmail.com)
// 
// Create Date: 26.04.2020 20:52:25
// Module Name: tb_steel_top
// Project Name: Steel Core
// Description: Steel Core testbench (Applies all tests from RISC-V Test Suite)
// 
// Dependencies: steel_core.v
// 
// Version 0.01
// 
//////////////////////////////////////////////////////////////////////////////////

/*********************************************************************************

MIT License

Copyright (c) 2020 Rafael de Oliveira Calcada

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

********************************************************************************/

`timescale 1ns / 1ps

module steel_core_64_tb();

    reg CLK;
    reg RESET;              
    wire [63:0] I_ADDR;
    reg [31:0] INSTR;        
    wire [63:0] D_ADDR;
    wire [63:0] DATA_OUT;
    wire WR_REQ;
    wire [7:0] WR_MASK;
    reg [63:0] DATA_IN;        
    reg E_IRQ;
    reg T_IRQ;
    reg S_IRQ;
    
    reg [8*20:0] tests [0:37] = {
        "rv32ui-p-addi.mem",
        "rv32ui-p-bgeu.mem",
        "rv32ui-p-lb.mem",
        "rv32ui-p-or.mem",
        "rv32ui-p-sltiu.mem",
        "rv32ui-p-sub.mem",
        "rv32ui-p-add.mem",
        "rv32ui-p-blt.mem",
        "rv32ui-p-lbu.mem",
        "rv32ui-p-sb.mem",
        "rv32ui-p-slt.mem",
        "rv32ui-p-sw.mem",
        "rv32ui-p-andi.mem",
        "rv32ui-p-bltu.mem",
        "rv32ui-p-lh.mem",
        "rv32ui-p-sh.mem",
        "rv32ui-p-sltu.mem",
        "rv32ui-p-xori.mem",
        "rv32ui-p-and.mem",
        "rv32ui-p-bne.mem",
        "rv32ui-p-lhu.mem",
        "rv32ui-p-simple.mem",
        "rv32ui-p-srai.mem",
        "rv32ui-p-xor.mem",
        "rv32ui-p-auipc.mem",
        "rv32ui-p-lui.mem",
        "rv32ui-p-slli.mem",
        "rv32ui-p-sra.mem",
        "rv32ui-p-beq.mem",
        "rv32ui-p-jal.mem",
        "rv32ui-p-lw.mem",
        "rv32ui-p-sll.mem",
        "rv32ui-p-srli.mem",
        "rv32ui-p-bge.mem",
        "rv32ui-p-jalr.mem",
        "rv32ui-p-ori.mem",
        "rv32ui-p-slti.mem",
        "rv32ui-p-srl.mem"
        };

    steel_core_top_64 #(
        
        .BOOT_ADDRESS(64'h00000000)
        
        ) dut (

        .CLK(CLK),
        .RESET(RESET),        
        .REAL_TIME(64'b0),        
        .I_ADDR(I_ADDR),
        .INSTR(INSTR),        
        .D_ADDR(D_ADDR),
        .DATA_OUT(DATA_OUT),
        .WR_REQ(WR_REQ),
        .WR_MASK(WR_MASK),
        .DATA_IN(DATA_IN),        
        .E_IRQ(E_IRQ),
        .T_IRQ(T_IRQ),
        .S_IRQ(S_IRQ)

    );
    
    reg [63:0] ram [0:16383];
    integer i;
    integer j;
    integer k;    
    
    always
    begin
        #10 CLK = !CLK;
    end
    
    initial
    begin
    
        for(k = 0; k < 38; k=k+1)
        begin
    
            // LOADS PROGRAM INTO MEMORY 
            for(i = 0; i < 65535; i=i+1) ram[i] = 8'b0;
            $display("Running %s...", tests[k]);
            $readmemh(tests[k],ram);            
            
            // INITIAL VALUES
            RESET = 1'b0;        
            CLK = 1'b0;        
            E_IRQ = 1'b0;
            T_IRQ = 1'b0;
            S_IRQ = 1'b0;
            
            // RESET
            #5;
            RESET = 1'b1;
            #15;
            RESET = 1'b0;
            
            // one second loop
            for(j = 0; j < 50000000; j = j + 1)
            begin
                #20;
                if(WR_REQ == 1'b1 && D_ADDR == 64'h0000000000001000)
                begin
                    $display("Result: %h", DATA_OUT);
                    #20;
                    j = 50000000;
                end
            end
            
        end
        
        $display("Steel Core testbench done. If all results are 0000000000000001 then everything works fine.");
        
    end
    
    always @(posedge CLK or posedge RESET)
    begin
        if(RESET)
        begin
            INSTR = ram[I_ADDR[16:2]];
            DATA_IN = ram[D_ADDR[16:3]];
        end
        else
        begin
            INSTR = ram[I_ADDR[16:2]];
            DATA_IN = ram[D_ADDR[16:3]];
            if(WR_REQ)
            begin
                if(WR_MASK[0])
                begin
                    ram[D_ADDR[16:3]][7:0] <= DATA_OUT[7:0];
                end
                if(WR_MASK[1])
                begin
                    ram[D_ADDR[16:3]][15:8] <= DATA_OUT[15:8];
                end
                if(WR_MASK[2])
                begin
                    ram[D_ADDR[16:3]][23:16] <= DATA_OUT[23:16];
                end
                if(WR_MASK[3])
                begin
                    ram[D_ADDR[16:3]][31:24] <= DATA_OUT[31:24];
                end
                if(WR_MASK[4])
                begin
                    ram[D_ADDR[16:3]][39:32] <= DATA_OUT[39:32];
                end
                if(WR_MASK[5])
                begin
                    ram[D_ADDR[16:3]][47:40] <= DATA_OUT[47:40];
                end
                if(WR_MASK[6])
                begin
                    ram[D_ADDR[16:3]][55:48] <= DATA_OUT[55:48];
                end
                if(WR_MASK[7])
                begin
                    ram[D_ADDR[16:3]][63:56] <= DATA_OUT[63:56];
                end
            end
        end
    end

endmodule
