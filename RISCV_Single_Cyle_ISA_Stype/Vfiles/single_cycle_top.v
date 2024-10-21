`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:12:15 10/15/2024 
// Design Name: 
// Module Name:    single_cycle_top 
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
module single_cycle_top(clk,rst    );
	input clk,rst;
	
	wire [31:0] PC_TOP,PCPlus4,RD_Instr,ReadData,RD1_Top,RD2_Top,Imm_Ext_Top,ALUresult;
	wire [2:0] ALUControl_Top;
	wire RegWrite,MemWrite;
	wire [1:0]ImmSrc;
	P_c PC (
		.PC_Next(PCPlus4), 
		.rst(rst), 
		.clk(clk), 
		.PC(PC_TOP)
			);
	 
	 Instruction_memory IM (
    .A(PC_TOP), 
    .rst(rst), 
    .RD(RD_Instr)
    );
	 
	 Register_File RF (
    .clk(clk), 
    .rst(rst), 
    .A1(RD_Instr[19:15]), 
    .A2(RD_Instr[24:20]), 
    .A3(RD_Instr[11:7]), 
    .WE3(RegWrite), 
    .WD3(ReadData), 
    .RD1(RD1_Top), 
    .RD2(RD2_Top)
    );
	
	Extend Ext (
    .Instr_in(RD_Instr), 
    .ImmSrc(ImmSrc[0]), 
    .Imm_Ext_out(Imm_Ext_Top)
    );
	 
	 alu ALU (
    .A_in(RD1_Top), 
    .B_in(Imm_Ext_Top), 
    .alu_ctrl_in(ALUControl_Top), 
    .result_o(ALUresult), 
    .Z(), 
    .N(), 
    .V(), 
    .C()
    );
	 
	 Control_Unit_Top CU_TOP (
    .Op(RD_Instr[6:0]), 
    .RegWrite(RegWrite), 
    .ImmSrc(ImmSrc), 
    .ALUSrc(), 
    .MemWrite(MemWrite), 
    .ResultSrc(), 
    .Branch(), 
    .funct3(RD_Instr[14:12]), 
    .funct7(), 
    .ALUControl(ALUControl_Top)
    );

	Data_Memory DM (
    .A(ALUresult), 
    .WE(MemWrite), 
    .clk(clk), 
    .rst(rst), 
    .WD(RD2_Top), 
    .RD(ReadData)
    );

	 PC_Adder PC_Add (
    .a(PC_TOP), 
    .b(32'd4), 
    .c(PCPlus4)
    );

endmodule
