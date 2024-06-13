`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2024 11:38:16 AM
// Design Name: 
// Module Name: tb_para_fifo
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


module tb_para_fifo();
 parameter DATA_W = 8;
 parameter DEPTH  = 32;

 logic              clk;
 logic              reset;

 logic              w_en;
 logic[DATA_W-1:0]  data_in;

 logic              r_en;
 logic[DATA_W-1:0]  data_out;

 logic              full;
 logic              empty;

 // Instantiate the RTL
 para_fifo #(.DEPTH(DEPTH), .DATA_W(DATA_W)) Day19(.*);

    always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
    end
    
    initial begin
    reset = 1'b1;
    w_en = 1'b0;
    r_en = 1'b0;
    @(posedge clk);
    reset = 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i =0; i<DEPTH; i++)begin
        w_en = 1'b1;
        data_in = $urandom_range(0,2**DATA_W-1);
    @(posedge clk);
    end
    w_en = 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i =0; i<DEPTH; i++)begin
    r_en = 1'b1;
    @(posedge clk);
    end
    r_en <= 1'b0;
        @(posedge clk);
        @(posedge clk);
        w_en      <= 1'b1;
        data_in <= $urandom_range(0, 2**DATA_W-1);
        @(posedge clk);
        w_en      <= 1'b0;
        // Push and pop both
        for (int i=0; i<DEPTH; i++) begin
          w_en      <= 1'b1;
          r_en       <= 1'b1;
          data_in <= $urandom_range(0, 2**DATA_W-1);
          @(posedge clk);
        end
        w_en <= 1'b0;
        r_en <= 1'b0;
        @(posedge clk);
        @(posedge clk);
        $finish();
      end
    
      // Dump vcd
      initial begin
        $dumpfile("day19.vcd");
        $dumpvars(0, tb_para_fifo);
      end
    

    

endmodule
