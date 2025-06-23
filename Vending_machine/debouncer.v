`timescale 1ns / 1ps
//This module synchronizes the unreliable input to the clk and then keeps it high
//until the next slow_clk rising edge. 
module debouncer(clk, clock_div, in, out);
	input clk;
	input clock_div;
	input in;
	output reg out = 1'b0;
	
	reg sync = 1'b0;
	reg sync2 = 1'b0;
	reg sync3 = 1'b0;
	reg clock_div_prev = 1'b0;
	reg out_prev = 1'b0;
	
	always @(posedge clk) begin
		
		sync <= in;
		sync2 <= sync;
		sync3 <= sync2;
		
		//store the previous clock_div and output
		clock_div_prev <= clock_div;
		out_prev <= out;	
		
		//output is set high when a pulse just happened, or
		//the previous pulse was high, and the clock_div is on a rising edge, or
		// the previous pulse was high and now low before a rising edge
		out <= (!sync3 && sync2) || (out && (!(clock_div && !clock_div_prev) || !out_prev));
	end
endmodule

