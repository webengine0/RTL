`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 08:02:32 PM
// Design Name: 
// Module Name: seq_detector
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


module seq_detector(
    input wire clk,
    input wire reset,
    
    input wire x_i,
    
    output wire det_o
    );
    
    logic [11:0] shift_ff;
    logic [11:0] nxt_shift;
    always_ff @(posedge clk or posedge reset)
    if(reset)
        shift_ff <= 12'h0;
    else 
        shift_ff <= nxt_shift;
    
    assign nxt_shift = {x_i,shift_ff[11:1]};
    
    
    assign det_o = (shift_ff[11:0] == 12'b1110_1101_1011);

endmodule
