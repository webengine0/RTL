`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:04:49 10/15/2024 
// Design Name: 
// Module Name:    Control_Unit_Top 
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
module Control_Unit_Top(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,funct3,funct7,ALUControl);

		input [6:0] Op,funct7;
		input [2:0] funct3;
		output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
		output [1:0]ImmSrc;
		output [2:0]ALUControl;
		
		wire [1:0] ALUOP;
		
		
	main_decoder Main_Decod (
    .Z(), 
    .branch(Branch), 
    .op(Op), 
    .PCsrc(), 
    .Memwrite(MemWrite), 
    .Resultsrc(ResultSrc), 
    .ALUsrc(ALUsrc), 
    .Immsrc(Immsrc), 
    .Regwrite(RegWrite), 
    .ALUop(ALUOP)
    );

		
	alu_decoder ALU_Decod (
    .op5(Op), 
    .ALUop(ALUOP), 
    .fnct3(fnct3), 
    .fnct7(fnct7), 
    .ALUctrl(ALUControl)
    );



endmodule
