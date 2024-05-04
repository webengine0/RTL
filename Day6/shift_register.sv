`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 07:48:01 AM
// Design Name: 
// Module Name: shift_register
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


module shift_register(
    input wire clk,
    input wire reset,
    input wire x_i, //serial input
    
    output wire [3:0] sr_o
  );
  
  logic [3:0]sr_ff;
  logic [3:0]nxt_sr;
  
  always_ff@(posedge clk or posedge reset)
    if(reset)
        sr_ff <= 4'h0;
    else
        sr_ff <= nxt_sr;
  
  assign nxt_sr = {sr_ff[2:0],x_i};
  assign sr_o = sr_ff;
  
endmodule
