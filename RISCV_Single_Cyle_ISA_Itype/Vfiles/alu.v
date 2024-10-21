`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:04:25 10/12/2024 
// Design Name: 
// Module Name:    alu 
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
module alu( A_in,B_in,alu_ctrl_in,result_o, Z,N,V,C );
	//Declaring Inputs
	input [31:0] A_in;
	input [31:0] B_in;
	input [2:0] alu_ctrl_in;
	
	//Declaring Output
	output [31:0] result_o;
	output Z,N,V,C;
	
	//Declaring Interim Wires
	 wire [31:0] a_and_b;
	 wire [31:0] a_or_b;
	 wire [31:0] not_b;
	 wire [31:0] mux_1;
	 wire [31:0] mux_2;
	 wire [31:0] slt_instruction;
	 wire cout_o;
	 
	 
	 wire [31:0] add_sub;
	 wire [31:0] sum;
	 
	 //Logic Desing
		//AND operation
		assign a_and_b = A_in & B_in;
		//OR operation
		assign a_or_b = A_in | B_in;
		//NOT operation
		assign not_b = ~B_in;
	
	//Ternary operations
	assign mux_1 = (alu_ctrl_in[0]==1'b0) ? B_in : not_b;
	 
	//Addition and Subtraction
	assign {cout,sum} = A_in + mux_1 + alu_ctrl_in[0];
	
	//Designing 4by1 mux
	assign mux_2 = (alu_ctrl_in==3'b000) ? sum : (alu_ctrl_in==3'b001) ? sum :
						(alu_ctrl_in==2'b010)? a_and_b : (alu_ctrl_in==2'b011)? a_or_b :(alu_ctrl_in==2'b101)? slt_instruction : 31'd0 ;
	
	//output result
	assign result_o = mux_2;
	
	//zero extension
	assign slt_instruction = {31'd0,mux_2[31]};
	
	//Zero flag
	assign Z = &(~result_o);
	//Negative flag
	assign N = result_o[31];
	//Carry flag
	assign C = (~alu_ctrl_in[1]) & cout;
	//overflow
	assign V = (~alu_ctrl_in[1]) & (sum[31] ^ A_in[31]) & (~(A_in[31] ^ B_in[31] ^ alu_ctrl_in[0]));
	
	


endmodule
