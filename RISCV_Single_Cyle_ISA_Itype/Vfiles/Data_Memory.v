`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:53 10/13/2024 
// Design Name: 
// Module Name:    Data_Memory 
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
//Data Memory is for permanent use
module Data_Memory(A,WE,clk,rst,WD,RD);

		input [31:0]A,WD;
		input clk,WE,rst;
		output [31:0]RD;
		
		reg [31:0]D_MEM [1023:0];
		assign RD = (!rst & WE==1'b0) ? 32'd0 : D_MEM[A];
		
		always @(posedge clk)
		begin
			if(!rst)
			begin
				D_MEM[A] <= 32'd0;
			end
			else
			begin
				if(WE==1'b1)
				begin
				D_MEM[A] <= WD;
				end
			end
		end
		initial begin
		D_MEM[28] = 32'h00000020;
		
		end
endmodule
