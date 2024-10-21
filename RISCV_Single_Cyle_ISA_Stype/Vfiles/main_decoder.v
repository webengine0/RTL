`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:18:25 10/13/2024 
// Design Name: 
// Module Name:    main_decoder 
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
module main_decoder(
		Z,op,PCsrc,branch,Memwrite,Resultsrc,ALUsrc,Immsrc,Regwrite,ALUop
    );
	 //Declaring Inputs
	 input Z;
	 output branch;
	 input [6:0]op;
	 //Declaring Outputs
	 output PCsrc,Memwrite,ALUsrc,Regwrite,Resultsrc;
	 output [1:0]Immsrc;
	 output [1:0]ALUop;

	//Declaring Interim Wires
	


		assign Regwrite = ((op == 7'b0000011) | (op == 7'b0110011))? 1'b1 : 1'b0; 
		assign Memwrite = ((op == 7'b0100011) ? 1'b1:1'b0);
		assign Resultsrc = ((op == 7'b0000011) ? 1'b1:1'b0);
		assign Immsrc = ((op == 7'b0100011) ? 2'b01 : (op == 7'b1100011))? 2'b10 : 2'b00; 
		assign ALUsrc = ((op == 7'b0000011) | (op == 7'b0100011))? 1'b1 : 1'b0; 
		assign ALUop = ((op == 7'b1100011) ? 2'b01 : (op == 7'b0110011))? 2'b10 : 2'b00; 
		assign branch = ((op == 7'b1100011) ? 1'b1:1'b0);
		assign PCsrc = branch & Z;


endmodule
