`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:15:35 10/13/2024 
// Design Name: 
// Module Name:    alu_decoder 
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
module alu_decoder(
	op5,ALUop,fnct3,fnct7,ALUctrl
    );
		//Declaring Inputs
	 input op5,fnct7;
	 input [1:0] ALUop;
	 input [2:0] fnct3;
		//Declaring Outputs
	 output [2:0]ALUctrl;
	 //Interim wire
	 wire concatenation;
	 
	 assign concatenation = {op5,fnct7};
	 assign ALUctrl = (ALUop==2'b00) ? 3'b000 :
							(ALUop==2'b01) ? 3'b001 :
							((ALUop==2'b10) & (fnct3 == 3'b000) & (concatenation != 2'b11)) ? 3'b000 :
							((ALUop==2'b10) & (fnct3 == 3'b000) & (concatenation == 2'b11)) ? 3'b001 :
							((ALUop==2'b10) & (fnct3 == 3'b010)) ? 3'b101 :
							((ALUop==2'b10) & (fnct3 == 3'b110)) ? 3'b011 :
							((ALUop==2'b10) & (fnct3 == 3'b111)) ? 3'b010 : 3'b000;
							
	 
	 
endmodule
