`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 06:48:50 AM
// Design Name: 
// Module Name: tb_ALU
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


module tb_ALU();

logic [7:0] a_i,b_i;
logic [2:0]op_i;
logic [7:0]alu_o;

ALU day4(.*);

initial begin
    for(int j=0; j<3; j++) begin
        for(int i=0; i<7; i++)begin
        a_i = $urandom_range(0,8'hff);
        b_i = $urandom_range(0,8'hff);
        op_i = 3'(i);
        #5;
        end
      end
end
initial begin
$dumpfile("day4.vcd");
$dumpvars(0,tb_ALU);
end
endmodule
