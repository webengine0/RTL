`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 08:02:47 PM
// Design Name: 
// Module Name: tb_seq_detector
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


module tb_seq_detector();
    
    logic clk,reset,x_i,det_o;
    
    seq_detector Day12(.*);
    
    always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
    end
    
    logic [11:0]seq = 12'b1110_1101_1011;
    logic [2:0]i;
    logic [11:0]j;
    initial begin
    reset = 1'b1;
    @(posedge clk);
    reset = 1'b0;
    for (  i = 0; i<4; i++)begin
        for(  j=0; j<12; j++)begin
            if(i==1 || i==2)begin
                x_i = seq[j];
            end
            else begin
              x_i = 1'b0;
            end
            @(posedge clk);
        end
    end
    
    end
//logic [11:0] seq = 12'b1110_1101_1011;
//logic [11:0] i;
//logic [11:0] j;
//  initial begin
//    reset <= 1'b1;
//    x_i <= 1'b1;
//    @(posedge clk);
//    reset <= 1'b0;
//    @(posedge clk);
//    for ( i=0; i<12; i=i+1) begin
//      x_i <= seq[i];
//      @(posedge clk);
//    end
//    for ( j=0; j<12; j=j+1) begin
//      x_i <= $random%2;
//      @(posedge clk);
//    end
//    $finish();
//  end

//  initial begin
//    $dumpfile("day12.vcd");
//    $dumpvars(0, tb_seq_detector);
//  end

endmodule
