//If you have trouble finding where to complete the code
//Do Ctrl+F "FILL IN"

`timescale 1ns/1ns
module matmul_tb;

    reg clk;
    reg resetn;
    reg pe_resetn;
    reg start;
    reg clear_done;

    //DUT
    matrix_multiplication u_matmul(
        .clk(clk), 
        .resetn(resetn), 
        .pe_resetn(pe_resetn), 
        .address_mat_a(10'b0),
        .address_mat_b(10'b0),
        .address_mat_c(10'b0),
        .address_stride_a(8'd1),
        .address_stride_b(8'd1),
        .address_stride_c(8'd1),
        .validity_mask_a_rows(4'b1111),
        .validity_mask_a_cols_b_rows(4'b1111),
        .validity_mask_b_cols(4'b1111),
        .start_reg(start),
        .clear_done_reg(clear_done)
        );
    
    //Clock Generation  
    initial 
    begin
        clk = 0;
        forever 
        begin
            #10 clk = ~clk;
        end
    end
    
    //Reset
    initial 
    begin
        resetn = 0;
        pe_resetn = 0;
        #55;
        resetn = 1;
        pe_resetn = 1;
    end
    
    //Perform test
    //Note: If you modify this to perform multiple matmuls, the result will be accumulated
    //This is because the PE is a MAC and has values from the previous run
    //Therefore, the MAC will accumulate unless pe_resetn is deasserted
    //For the purpose of this lab, we are only doing the multiplication once
    initial 
    begin
        start = 0;
        #115 start = 1;
        @(posedge u_matmul.done_mat_mul);
        start = 0;
        clear_done = 1;
        #200;
        $finish;
    end
    

// Sample test case
//  A           B       Output   Output in hex
// 1 1 1 1   1 1 1 1   4 4 4 4    4 4 4 4
// 1 1 1 1   1 1 1 1   4 4 4 4    4 4 4 4
// 1 1 1 1   1 1 1 1   4 4 4 4    4 4 4 4
// 1 1 1 1   1 1 1 1   4 4 4 4    4 4 4 4
//You can verify output through waveforms by adding scope object u_matmul.matrix_C.ram 

//    integer i;
   
//   initial 
//   begin
//       for (i=0; i<4; i = i + 1) 
//       begin
//           u_matmul.matrix_A.ram[i] = {8'h01, 8'h01, 8'h01, 8'h01};
//           u_matmul.matrix_B.ram[i] = {8'h01, 8'h01, 8'h01, 8'h01};
//       end
//   end
       
    

//Actual test case
//  A           B        Output       Output in hex
// 8 4 6 8   1 1 3 0   98 90 82 34    62 5A 52 22
// 3 3 3 7   0 1 4 3   75 63 51 26    4B 3F 33 1A
// 5 2 1 6   3 5 3 1   62 48 44 19    3E 30 2C 13
// 9 1 0 5   9 6 3 2   54 40 46 13    36 28 2E 0D
//You do not need to use a for loop to initialize matrices, as shown below

initial begin
   //FILL IN REST OF THE CODE 
   //A is stored in ROW MAJOR format
   //A[0][0] (8'h08) should be the least significant byte of ram[0]
   //The first column of A should be read together. So, it needs to be 
   //placed in the first matrix_A ram location.
   //This is due to Verilog conventions declaring {MSB, ..., LSB}
   u_matmul.matrix_A.ram[0]  = {8'h09, 8'h05, 8'h03, 8'h08}; //Update this line
   u_matmul.matrix_A.ram[1]  = {8'h01, 8'h02, 8'h03, 8'h04};//Complete this line
   u_matmul.matrix_A.ram[2]  = {8'h00, 8'h01, 8'h03, 8'h06};//Complete this line
   u_matmul.matrix_A.ram[3]  = {8'h05, 8'h06, 8'h07, 8'h08};//Complete this line
 
  //B is stored in COL MAJOR format
   //B[0][0] (8'h01) should be the least significant of ram[0]
   //The first row of B should be read together. So, it needs to be 
   //placed in the first matrix_B ram location.
   u_matmul.matrix_B.ram[0]  = {8'h00, 8'h03, 8'h01, 8'h01};//Complete this line
   u_matmul.matrix_B.ram[1]  = {8'h03, 8'h04, 8'h01, 8'h00};//Complete this line
   u_matmul.matrix_B.ram[2]  = {8'h01, 8'h03, 8'h05, 8'h03};//Complete this line
   u_matmul.matrix_B.ram[3]  = {8'h02, 8'h03, 8'h06, 8'h09};//Complete this line
end



endmodule