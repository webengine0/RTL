`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 05:26:32 AM
// Design Name: 
// Module Name: dff
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


module dff(
input logic clk,
input logic reset,

input logic d_i,

output logic q_norst_o, //non resetable flip flop
output logic q_syncrst_o, //sync resetable flip flop
output logic q_asyncrst_o //async resetable flip flop
   );
   
   always_ff @(posedge clk)
    q_norst_o <= d_i;
    
    always_ff @(posedge clk or posedge reset)
    if(reset)
        q_syncrst_o <= 1'b0;
    else
        q_syncrst_o <= d_i;
        
        
     always_ff @(posedge clk or reset)
        if(reset)
          q_asyncrst_o <= 1'b0;
      else
          q_asyncrst_o <= d_i;

   
   
endmodule
