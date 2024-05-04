`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 05:38:52 AM
// Design Name: 
// Module Name: tb_dff
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


module tb_dff();
    logic clk;
    logic reset;
    logic d_i;
    logic q_norst_o;
    logic q_syncrst_o;
    logic q_asyncrst_o;
    
    dff day02(.*);
    always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
    end
    //Stimulus
    initial begin
   reset = 1'b1;
        d_i = 1'b0;
        @(posedge clk);
        reset = 1'b0;
        @(posedge clk);
        d_i = 1'b1;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        reset = 1'b1;
        @(posedge clk);
        @(posedge clk);
        reset = 1'b0;
        @(posedge clk);
        @(posedge clk);
        $finish();
        
    end
    //Dump VCD file
    initial begin
    $dumpfile("day02.vcd");
    $dumpvars(0,tb_dff);
    end
    
endmodule
