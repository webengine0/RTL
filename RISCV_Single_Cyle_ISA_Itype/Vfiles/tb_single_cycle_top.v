`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:34:01 10/19/2024
// Design Name:   single_cycle_top
// Module Name:   E:/1. RTL Learning/RSIC/RISC_single_cycle/tb_single_cycle_top.v
// Project Name:  RISC_single_cycle
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: single_cycle_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_single_cycle_top;

	// Inputs
	reg clk;
	reg rst;

	// Instantiate the Unit Under Test (UUT)
	single_cycle_top uut (
		.clk(clk), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#150;
		  rst = 1'b1;
		#500;
      $finish;

		// Add stimulus here

	end
      always #5 clk = ~clk;
endmodule

