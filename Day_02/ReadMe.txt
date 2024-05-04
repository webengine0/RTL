DFF code
module dff(
input logic clk,
input logic reset,

input logic d_i,

output logic q_norst_o, //non resetable flip flop
output logic q_syncrst_o, //sync resetable flip flop
output logic q_asyncrst_o //async resetable flip flop
   );   
   always_ff @(posedge clk)
    q_norst_o <= d_i;
        
always_ff @(posedge clk or posedge reset)
    if(reset)
        q_syncrst_o <= 1'b0;
    else
        q_syncrst_o <= d_i;
        
     always_ff @(posedge clk or reset)
        if(reset)
          q_asyncrst_o <= 1'b0;
      else
          q_asyncrst_o <= d_i; 
endmodule

Test Bench Code

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
        
    End

    //Dump VCD file
endmodule  
  initial begin
      $dumpfile("mux.vcd"); //specifies the filename ("mux.vcd") for the VCD file where simulation waveform data will be stored.
      $dumpvars(0, tb_mux);
    end


endmodule

Summary
1.	always @(posedge clk) is a construct in Verilog. It is sensitive to the positive edge of the clk signal and executes whenever the clk signal transitions from 0 to 1. However, it doesn't guarantee any specific timing relationship between the clock and the execution of the block inside it.
2.	always_ff @(posedge clk) is a construct introduced in SystemVerilog. It also triggers on the positive edge of the clk signal like always @(posedge clk), but it's specifically designed for synthesizable, flip-flop-based designs. It enforces stricter rules regarding the use of blocking assignments within the block and ensures proper synthesis behavior. It's generally preferred for describing synchronous logic in modern SystemVerilog designs.

