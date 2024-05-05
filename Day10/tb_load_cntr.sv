`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 09:42:57 AM
// Design Name: 
// Module Name: tb_load_cntr
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


module tb_load_cntr();

        
  logic          clk;
  logic          reset;
  logic          load_i;
  logic[3:0]     load_val_i;

  logic[3:0]     count_o;

  load_cntr day10 (.*);

  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
   int cycles;
   initial begin
     reset <= 1'b1;
     load_i <= 1'b0;
     load_val_i <= 4'h0;
     @(posedge clk);
     reset <= 1'b0;
     for (int i=0; i<3; i=i+1) begin
       load_i <= 1;
       load_val_i <= 3*i;
       cycles = 4'hF - load_val_i[3:0];
       @(posedge clk);
       load_i <= 0;
       while (cycles) begin
         cycles = cycles - 1;
         @(posedge clk);
       end
     end
     $finish();
   end
 
   initial begin
     $dumpfile("day10.vcd");
     $dumpvars(2, tb_load_cntr);
   end
        
endmodule
