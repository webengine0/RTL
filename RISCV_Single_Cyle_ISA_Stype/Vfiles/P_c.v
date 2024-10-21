`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:56 10/13/2024 
// Design Name: 
// Module Name:    P_c 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module P_c(PC_Next,rst,clk,PC
    );
	 input [31:0]PC_Next;
	 input rst;
	 input clk;
	 output reg [31:0]PC;
	 
	 always @(posedge clk)
	 begin
		if(~rst)
		begin
			PC <= 32'd0;
		end
		else
		begin
			PC <= PC_Next;
		end
	 end
	 

endmodule
