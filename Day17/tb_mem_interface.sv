`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 04:16:50 PM
// Design Name: 
// Module Name: tb_mem_interface
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


module tb_mem_interface();

     logic        clk;
  logic        reset;
  logic        req_i;
  logic        req_rnw_i;
  logic[9:0]   req_addr_i;
  logic[31:0]  req_wdata_i;
  logic        req_ready_o;
  logic[31:0]  req_rdata_o;

  // Instatiate the RTL
  mem_interface DAY17 (.*);

  logic [9:0] [9:0] addr_list;

  // Generate the clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Generate stimulus
  initial begin
    reset <= 1'b1;
    req_i <= 1'b0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int txn=0; txn<10; txn++) begin
      // Write 10 transactions
      req_i       <= 1'b1;
      req_rnw_i   <= 0;
      req_addr_i  <= $urandom_range(0, 1023);
      addr_list[txn] = req_addr_i;
      req_wdata_i <= $urandom_range(0, 32'hFFFF);
      // Wait for ready
      while (~req_ready_o) begin
        @(posedge clk);
      end
      req_i <= 1'b0;
      @(posedge clk);
    end
    for (int txn=0; txn<10; txn++) begin
      // Read 10 transactions
      req_i       <= 1'b1;
      req_rnw_i   <= 1;
      req_addr_i  <= addr_list[txn];
      req_wdata_i <= $urandom_range(0, 32'hFFFF);
      // Wait for ready
      while (~req_ready_o) begin
        @(posedge clk);
      end
      req_i <= 1'b0;
      @(posedge clk);
    end
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("mem_interface.vcd");
    $dumpvars(0, tb_mem_interface);
  end
    

endmodule
