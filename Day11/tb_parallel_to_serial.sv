`timescale 1ns / 1ps

module tb_parallel_to_serial ();

  logic      clk;
  logic      reset;

  logic      empty_o;
  logic[3:0] parallel_i;
  logic      serial_o;
  logic      valid_o;

  parallel_to_serial DAY11 (.*);

  // Clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Stimulus
  initial begin
    reset <= 1'b1;
    parallel_i <= 4'h0;
    @(negedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int i=0; i<32; i=i+1) begin
      parallel_i <= $urandom_range(0, 4'hF);
      @(posedge clk);
    end
    $finish();
  end

  // VCD
  initial begin
    $dumpfile("day11.vcd");
    $dumpvars(0, tb_parallel_to_serial);
  end

endmodule