`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 09:33:41 AM
// Design Name: 
// Module Name: tb_binto_1hot
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


    module tb_binto_1hot();
    
      localparam BIN_W = 4;
      localparam ONE_HOT_W = 16;
    
      logic [BIN_W-1:0] bin_i;
      logic [ONE_HOT_W-1:0] one_hot_o;
    
      binto_onehot #(BIN_W, ONE_HOT_W) DAY8 (.*);
    
      initial begin
        for(int i=0; i<32; i=i+1) begin
          bin_i = $urandom_range(0, 4'hF);
          #5;
        end
        $finish();
      end
    
      initial begin
        $dumpfile("day8.vcd");
        $dumpvars(2, tb_binto_1hot);
      end
    
    endmodule

