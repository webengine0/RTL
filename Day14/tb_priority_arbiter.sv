`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 06:30:47 AM
// Design Name: 
// Module Name: tb_priority_arbiter
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


module tb_priority_arbiter();

    localparam NUM_PORTS = 8;
    
    logic [NUM_PORTS-1:0] req_i;
    logic [NUM_PORTS-1:0] gnt_o;
    
    priority_arbiter #(NUM_PORTS) day14(.*);

 initial begin
    for (int i=0; i<32; i=i+1) begin
      req_i = $urandom_range(0, 2**NUM_PORTS-1);
      #5;
    end
  end

  initial begin
    $dumpfile("day14.vcd");
    $dumpvars(0, tb_priority_arbiter);
  end


endmodule
