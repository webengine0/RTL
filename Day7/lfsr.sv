`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 08:27:45 AM
// Design Name: 
// Module Name: lfsr
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


module lfsr(
input wire clk,
input wire reset,

output wire [3:0]lfsr_o
    );
    
 
    logic [3:0]lfsr_ff;
    logic [3:0]nxt_lfsr;
    
    always_ff @(posedge clk)
    if(reset)
    lfsr_ff <= 4'hE;
    else
    lfsr_ff <= nxt_lfsr;
   
   
   assign nxt_lfsr = {lfsr_ff[2:0], lfsr_ff[1]^lfsr_ff[3]};

   assign lfsr_o=lfsr_ff;
    
endmodule
