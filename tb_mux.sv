`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2024 05:39:27 AM
// Design Name: 
// Module Name: tb_mux
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


module tb_mux();

logic [7:0] a_i;
logic [7:0] b_i;
logic sel_i;
logic [7:0] y_o;

    mux mux_1(.*);
    
    initial begin
    for (int i = 0; i <10; i=i++)begin
    a_i = $urandom_range (0,8'hff);
    b_i = $urandom_range (0,8'hff);
    sel_i = $random%2;
    #5;
    end
    end 
  
  initial begin
      $dumpfile("mux.vcd");
      $dumpvars(0, tb_mux);
    end


endmodule
