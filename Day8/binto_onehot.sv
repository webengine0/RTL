`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 09:22:46 AM
// Design Name: 
// Module Name: binto_onehot
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


module binto_onehot #(
    parameter BIN_W = 4,
    parameter ONE_HOT_W = 16
)(
    input wire [BIN_W-1:0] bin_i,
    output wire [ONE_HOT_W-1:0] one_hot_o
    );
    
    assign one_hot_o = 1'b1<<bin_i;
    
endmodule
