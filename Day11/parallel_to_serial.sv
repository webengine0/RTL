// Parallel to serial with valid and empty

module parallel_to_serial (
  input     wire      clk,
  input     wire      reset,

  output    wire      empty_o,
  input     wire[3:0] parallel_i,
  
  output    wire      serial_o,
  output    wire      valid_o
);

 logic [3:0]shift_ff;
 logic [3:0]nxt_shift;
 
 always_ff @(posedge clk or posedge reset)
 if(reset)
    shift_ff <= 4'h0;
 else
    shift_ff <= nxt_shift;
    
    assign nxt_shift = empty_o ? parallel_i :
                               {1'b0,shift_ff[3:1]};
        
        
    assign serial_o = shift_ff[0];
          
     logic [2:0]cnt_ff;
     logic [2:0]nxt_cnt;
     
     always_ff @(posedge clk or posedge reset)
     if(reset)
        cnt_ff <= 4'h0;
     else
        cnt_ff <= nxt_cnt;
     
         assign nxt_cnt = (cnt_ff == 3'h4)?3'h0 :
                                          cnt_ff + 3'h1;                    
     assign empty_o = (cnt_ff == 4'h0);
     
     assign valid_o = |cnt_ff;
     


endmodule