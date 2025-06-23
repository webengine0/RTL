`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:36:23 02/09/2021
// Design Name:   Vending_Machine
// Module Name:   C:/Users/user/Documents/task/Vending/vending_tb.v
// Project Name:  Vending
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Vending_Machine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vending_tb;

	// Inputs
	reg clk;
	reg quarter;
	reg nickel;
	reg dime;
	reg soda;
	reg diet;

	// Outputs
	wire Give_soda;
	wire Give_diet;

	// Instantiate the Unit Under Test (UUT)
	Vending_Machine uut (
		.clk(clk), 
		.quarter(quarter), 
		.nickel(nickel), 
		.dime(dime), 
		.soda(soda), 
		.diet(diet), 
		.Give_soda(Give_soda), 
		.Give_diet(Give_diet)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		quarter = 0;
		nickel = 0;
		dime = 0;
		soda = 0;
		diet = 0;

		// Wait 10 ns for global reset to finish
		#10;
		// Add stimulus here
		#10;   /// 1 quarter = 25 cent
		quarter = 1;
		nickel = 0;
		dime = 0;
		
        #10;  
		quarter = 0;
		nickel = 0;
		dime = 0;
		
        #10;   /// 1 quarter again so total cents = 25 cent + 25 cent= 50
		quarter = 1;
		nickel = 0;
		dime = 0;
        #10;
		  
		quarter = 0;
		nickel = 0;
		dime = 0;
		
        #10;   /// this will be neglected as money is above 45 cents
		quarter = 0;
		nickel = 1;
		dime = 0;
		
        #10;
		quarter = 0;
		nickel = 0;
		dime = 0;
		
		#20;
		soda = 1; /// sode is ordered
		
		#10;
		quarter = 0;
		nickel = 0;
		dime = 0;
		soda = 0;
        
		  #20;    /// 1 quarter and 1 nickel = 25+10=35
		quarter = 1;
		nickel = 1;
		dime = 0;
        #10;
		quarter = 0;
		nickel = 0;
		dime = 0;
		
		#10;   /// 1 nickel again so total cents = 35 cent + 10 cent= 45
		quarter = 0;
		nickel = 1;
		dime = 0;
		#10;
		quarter = 0;
		nickel = 0;
		dime = 0;
		
		#20;
		diet=1;  /// diet_soda is ordered
       #10;
		 diet=0;
		
        

	end
      always #5 clk=~clk;
endmodule

