`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 07:10:13 AM
// Design Name: 
// Module Name: odd_counter
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


module odd_counter(
    input wire clk,
    input wire reset,
    
    output logic [7:0] od_counter
    );
    
    logic [7:0]next_cnt;
    
    always_ff @(posedge clk or posedge reset)
    if(reset)
    od_counter <= 8'h1;
    else 
    od_counter <= next_cnt;
    
    assign next_cnt= od_counter + 2'h2;
    
endmodule
