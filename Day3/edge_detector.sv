`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 05:54:02 AM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
input wire clk,
input wire reset,

input wire a_i,

output wire rising_edge_o,
output wire falling_edge_o
    );
    
    logic a_ff;
    
    always @(posedge clk or posedge reset)
    if(reset)
    a_ff <= 1'b0;
    else
    a_ff <= a_i;
    
    assign rising_edge_o = ~a_ff & a_i;
    assign falling_edge_o = a_ff & ~a_i;
    
endmodule
