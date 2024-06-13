`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2024 11:37:11 AM
// Design Name: 
// Module Name: para_fifo
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


module para_fifo #(
    parameter DEPTH = 32,
    parameter DATA_W = 8)
(
    input wire clk,
    input wire reset,
    
    input wire w_en,
    input wire r_en,
    
    input wire [DATA_W-1:0]data_in,
    
    output wire [DATA_W-1:0]data_out,
    output wire empty,
    output wire full
    ); 
      logic [DEPTH-1:0][DATA_W-1:0]fifo_mem;
      
      parameter PTR_W = $clog2(DEPTH);
      logic [PTR_W-1:0]wr_ptr;
      logic [PTR_W-1:0]rd_ptr;
      logic [DATA_W-1:0] fifo_pop_data;
      
      always_ff @(posedge clk or posedge reset)
      begin
        if(reset)begin
            rd_ptr <= {PTR_W+1{1'b0}};
            wr_ptr <= {PTR_W+1{1'b0}};
            fifo_pop_data <={DATA_W+1{1'b0}};
            for(int i=0; i<32; i++) begin
                fifo_mem[i] <= {DATA_W+1{1'b0}};
            end
        end
        else
        begin
            if((w_en == 1'b1) && (full == 1'b0))
            begin
            fifo_mem[wr_ptr]<=data_in;
            wr_ptr <= wr_ptr + 1'b1;
            end
            if((r_en == 1'b1) && (empty == 1'b0))
            begin
            fifo_pop_data <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
            end
          end
        end  
        
        assign data_out = fifo_pop_data;
        assign empty = ((wr_ptr - rd_ptr) == 0)? 1'b1:1'b0;
        assign full = ((wr_ptr - rd_ptr) == 31)? 1'b1:1'b0;
      
        
 
                             
    
endmodule
