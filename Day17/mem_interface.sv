`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2024 07:44:17 AM
// Design Name: 
// Module Name: mem_interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem_interface(
    input wire clk,
    input wire reset,
    
    input wire req_i,
    input wire req_rnw_i,
    input wire [3:0]req_addr_i,
    input wire [31:0]req_wdata_i,
    
    output wire req_ready_o,
    output wire [31:0]req_rdata_o
    );
    
  //MEMORY ARRAY
  `ifdef FORMAL
  logic [31:0]mem[15:0];
  `else
  logic [15:0][31:0]mem;
  `endif
    
    logic mem_rd;
    logic mem_wr;
    
    
    logic req_rising_edge;
    
    logic [3:0]lfsr_val;
    logic [3:0]count;
    
    assign mem_rd = req_i & req_rnw_i;
    assign mem_wr = req_i & ~req_rnw_i;
    
    rising_edge day3(
    .clk(clk),
    .reset(reset),
    .a_i(req_i),
    .rising_edge_o(req_rising_edge)
    );
    
     lfsr day7(
       .clk(clk),
       .reset(reset),
       .lfsr_o(lfsr_val)
       );
    // Load a counter with random value on the rising edge
      logic[3:0] count_ff;
      logic[3:0] nxt_count;
    
      always_ff @(posedge clk or posedge reset)
        if (reset)
          count_ff <= 4'h0;
        else
          count_ff <= nxt_count;
    
      assign nxt_count = req_rising_edge ? lfsr_val:
                                           count_ff + 4'h1;
    
      assign count = count_ff;
      
   
    
     // Write into the mem when the counter is 0
     always_ff @(posedge clk)
       if (mem_wr & ~|count)
         mem[req_addr_i] <= req_wdata_i;
   
     // Read directly
     assign req_rdata_o = mem[req_addr_i] & {32{mem_rd}};
   
     // Assert ready only when counter is at 0
     // This will add random delays on when memory gives the ready
     assign req_ready_o = ~|count;
    
endmodule
