`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2024 07:53:44 AM
// Design Name: 
// Module Name: rising_edge
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


module rising_edge(
    input wire clk,
    input wire reset,
    
    input wire a_i,
    output wire rising_edge_o
    );
    
    logic a_ff;
    
    always_ff @(posedge clk or posedge reset)
    if(reset)
    a_ff <=1'b0;
    else
    a_ff <= a_i;
    
    
    assign rising_edge_o = ~a_ff & a_i;
    
endmodule
