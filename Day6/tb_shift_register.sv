`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 07:48:23 AM
// Design Name: 
// Module Name: tb_shift_register
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


module tb_shift_register();

logic clk,reset;
logic x_i;
logic [3:0]sr_o;

shift_register day6(.*);

always begin
clk=1'b0;
#5;
clk=1'b1;
#5;

end
initial begin
    reset <= 1'b1;
    x_i <= 1'b0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int i=0; i<16; i=i+1) begin
      x_i <= $random%2;
      @(posedge clk);
    end
    $finish();
  end

  // Dump VCD
  initial begin
    $dumpfile("day6.vcd");
    $dumpvars(2, tb_shift_register);
  end



endmodule
