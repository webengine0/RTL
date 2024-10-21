`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:53:33 10/13/2024 
// Design Name: 
// Module Name:    Instruction_memory 
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
module Instruction_memory( A,rst, RD
    );
	 
	 input [31:0]A;
	 input rst;
	 output [31:0]RD;

	reg [31:0] MEM [1023:0];
	
	assign RD = (~rst) ? 32'd0: MEM[A[31:2]]; 
	
	initial begin
//	MEM[0] = 32'hFFC4A303;	//I-Type
	MEM[0] = 32'h0064A423;	//S-Type
	
	end

endmodule
