`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 07:13:02 AM
// Design Name: 
// Module Name: tb_od_counter
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


module tb_od_counter();

logic clk,reset;
logic [7:0] od_counter;

odd_counter day5(.*);

always begin
clk= 1'b0;
#5;
clk=1'b1;
#5;
end

  initial begin
    reset <= 1'b1;
    @(posedge clk);
    @(posedge clk);
    reset <= 1'b0;
   for (int i=0;i<128;i++)
      @(posedge clk);
    $finish();
  end

  initial begin
    $dumpfile("day5.vcd");
    $dumpvars(0, tb_od_counter);
  end
  
endmodule
