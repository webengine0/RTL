`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 05:54:35 AM
// Design Name: 
// Module Name: tb_various_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Simple TB

module tb_various_mux ();

  
  logic [3:0] a_i;
  logic [3:0] sel_i;

  // Output using ternary operator
  logic     y_ter_o;
  // Output using case
  logic     y_case_o;
  // Ouput using if-else
  logic     y_ifelse_o;
  // Output using for loop
  logic     y_loop_o;
  // Output using and-or tree
  logic     y_aor_o;

  // Module instance
  various_mux day13(.*);

  // Stimulus
  initial begin
    for (int i =0; i<32; i++) begin
      a_i   = $urandom_range(0, 4'hF);
      sel_i = 1'b1 << $urandom_range(0, 2'h3); // one-hot
      #5;
    end
    $finish();
  end

  // VCD
  initial begin
    $dumpfile("day13.vcd");
    $dumpvars(0, tb_various_mux);
  end

endmodule