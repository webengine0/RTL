`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:33:59 10/15/2024 
// Design Name: 
// Module Name:    Extend 
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
module Extend(Instr_in,Imm_Ext_out
    );
	 input [31:0]Instr_in;

	 output [31:0] Imm_Ext_out;
	 
	 assign Imm_Ext_out = (Instr_in[31]) ? {{20{1'b1}},Instr_in[31:20]} : {{20{1'b0}},Instr_in[31:20]} ;
	


endmodule
