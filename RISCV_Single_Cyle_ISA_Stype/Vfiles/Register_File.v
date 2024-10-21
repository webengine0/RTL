`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:06:57 10/13/2024 
// Design Name: 
// Module Name:    Register_File 
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
//Register File is only for temporary use, registers will be overridden with time when we use that register again
module Register_File(clk,rst,A1,A2,A3,WE3,WD3,RD1,RD2  );
		
		//Declaring Inputs
		input [4:0]A1,A2,A3;
		input WE3,clk,rst;
		input [31:0]WD3;
    	//Declaring outputs
		output [31:0]RD1,RD2;
		//Declaring Memory of 32 width and 32 bit no. of memories
		reg [31:0] Register [31:0];
		
		
		assign RD1 = !rst ? 32'd0:Register[A1];
		assign RD2 = !rst ? 32'd0:Register[A2];
		
		always @(posedge clk)
		begin
			if(!rst)
			begin
				Register[A3] <= 32'd0;
			end
			else
			begin
				if(WE3)
				begin
					Register[A3] <= WD3;
				end
			end
		
		end
		
		initial begin
		Register[9] = 32'h00000020;
		Register[6] = 32'h00000040;
		end
		

endmodule
