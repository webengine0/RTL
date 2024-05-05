`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2024 08:05:07 PM
// Design Name: 
// Module Name: matmul
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

//If you have trouble finding where to complete the code
//Do Ctrl+F "FILL IN"
`timescale 1ns / 1ps
`define DWIDTH 8
`define AWIDTH 10
`define MEM_SIZE 1024

`define MAT_MUL_SIZE 4
`define MASK_WIDTH 4
`define LOG2_MAT_MUL_SIZE 2

`define BB_MAT_MUL_SIZE `MAT_MUL_SIZE
`define NUM_CYCLES_IN_MAC 3
`define MEM_ACCESS_LATENCY 1
`define REG_DATAWIDTH 32
`define REG_ADDRWIDTH 8
`define ADDR_STRIDE_WIDTH 8
`define MAX_BITS_POOL 3

module matmul_4x4_systolic(
    clk,
    reset,
    pe_reset,
    start_mat_mul,
    done_mat_mul,
    address_mat_a,
    address_mat_b,
    address_mat_c,
    address_stride_a,
    address_stride_b,
    address_stride_c,
    a_data,
    b_data,
    a_data_in, //Data values coming in from previous matmul - systolic connections
    b_data_in,
    c_data_in, //Data values coming in from previous matmul - systolic shifting
    c_data_out, //Data values going out to next matmul - systolic shifting
    a_data_out,
    b_data_out,
    a_addr,
    b_addr,
    c_addr,
    c_data_available,
    validity_mask_a_rows,
    validity_mask_a_cols_b_rows,
    validity_mask_b_cols,
    final_mat_mul_size,
    a_loc,
    b_loc
    );

    input clk;
    input reset;
    input pe_reset;
    input start_mat_mul;
    output done_mat_mul;
    input [`AWIDTH-1:0] address_mat_a;
    input [`AWIDTH-1:0] address_mat_b;
    input [`AWIDTH-1:0] address_mat_c;
    input [`ADDR_STRIDE_WIDTH-1:0] address_stride_a;
    input [`ADDR_STRIDE_WIDTH-1:0] address_stride_b;
    input [`ADDR_STRIDE_WIDTH-1:0] address_stride_c;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_in;
    output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_out;
    output [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_out;
    output [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_out;
    output [`AWIDTH-1:0] a_addr;
    output [`AWIDTH-1:0] b_addr;
    output [`AWIDTH-1:0] c_addr;
    output c_data_available;
    input [`MASK_WIDTH-1:0] validity_mask_a_rows;
    input [`MASK_WIDTH-1:0] validity_mask_a_cols_b_rows;
    input [`MASK_WIDTH-1:0] validity_mask_b_cols;
    //7:0 is okay here. We aren't going to make a matmul larger than 128x128
    //In fact, these will get optimized out by the synthesis tool, because
    //we hardcode them at the instantiation level.
    input [7:0] final_mat_mul_size;
    input [7:0] a_loc;
    input [7:0] b_loc;

//////////////////////////////////////////////////////////////////////////
// Logic for clock counting and when to assert done
//////////////////////////////////////////////////////////////////////////

    reg done_mat_mul;
    //This is 7 bits because the expectation is that clock count will be pretty
    //small. For large matmuls, this will need to increased to have more bits.
    //In general, a systolic multiplier takes f(N)+P cycles, where N is the size 
    //of the matmul and P is the number of pipleine stages in the MAC block.
    //f(N) is a function describing the number of cycles taken to perform matmul
    //with a systolic array strcture.
    reg [7:0] clk_cnt;
    
    //Finding out number of cycles to assert matmul done.
    wire [7:0] clk_cnt_for_done;
    wire [7:0] cycles_for_matmul; 
    
    //FILL IN THE CODE (x)
    assign cycles_for_matmul = 8'd14;
    assign clk_cnt_for_done = (cycles_for_matmul + `NUM_CYCLES_IN_MAC) ;  


    always @(posedge clk) 
    begin
        if (reset || ~start_mat_mul) 
        begin
            clk_cnt <= 0;
            done_mat_mul <= 0;
        end
        else if (clk_cnt == clk_cnt_for_done) 
        begin
            done_mat_mul <= 1;
            clk_cnt <= clk_cnt + 1;
        end
        else if (done_mat_mul == 0) 
            clk_cnt <= clk_cnt + 1;   
        else 
        begin
            done_mat_mul <= 0;
            clk_cnt <= clk_cnt + 1;
        end
    end


    wire [`DWIDTH-1:0] a0_data;
    wire [`DWIDTH-1:0] a1_data;
    wire [`DWIDTH-1:0] a2_data;
    wire [`DWIDTH-1:0] a3_data;
    wire [`DWIDTH-1:0] b0_data;
    wire [`DWIDTH-1:0] b1_data;
    wire [`DWIDTH-1:0] b2_data;
    wire [`DWIDTH-1:0] b3_data;
    wire [`DWIDTH-1:0] a1_data_delayed_1;
    wire [`DWIDTH-1:0] a2_data_delayed_1;
    wire [`DWIDTH-1:0] a2_data_delayed_2;
    wire [`DWIDTH-1:0] a3_data_delayed_1;
    wire [`DWIDTH-1:0] a3_data_delayed_2;
    wire [`DWIDTH-1:0] a3_data_delayed_3;
    wire [`DWIDTH-1:0] b1_data_delayed_1;
    wire [`DWIDTH-1:0] b2_data_delayed_1;
    wire [`DWIDTH-1:0] b2_data_delayed_2;
    wire [`DWIDTH-1:0] b3_data_delayed_1;
    wire [`DWIDTH-1:0] b3_data_delayed_2;
    wire [`DWIDTH-1:0] b3_data_delayed_3;
    
//////////////////////////////////////////////////////////////////////////
// Instantiation of systolic data setup
//////////////////////////////////////////////////////////////////////////
    systolic_data_setup u_systolic_data_setup(
        .clk(clk),
        .reset(reset),
        .start_mat_mul(start_mat_mul),
        .a_addr(a_addr),
        .b_addr(b_addr),
        .address_mat_a(address_mat_a),
        .address_mat_b(address_mat_b),
        .address_stride_a(address_stride_a),
        .address_stride_b(address_stride_b),
        .a_data(a_data),
        .b_data(b_data),
        .clk_cnt(clk_cnt),
        .a0_data(a0_data),
        .a1_data_delayed_1(a1_data_delayed_1),
        .a2_data_delayed_2(a2_data_delayed_2),
        .a3_data_delayed_3(a3_data_delayed_3),
        .b0_data(b0_data),
        .b1_data_delayed_1(b1_data_delayed_1),
        .b2_data_delayed_2(b2_data_delayed_2),
        .b3_data_delayed_3(b3_data_delayed_3),
        .validity_mask_a_rows(validity_mask_a_rows),
        .validity_mask_a_cols_b_rows(validity_mask_a_cols_b_rows),
        .validity_mask_b_cols(validity_mask_b_cols),
        .final_mat_mul_size(final_mat_mul_size),
        .a_loc(a_loc),
        .b_loc(b_loc)
        );


//////////////////////////////////////////////////////////////////////////
// Logic to mux data_in coming from neighboring matmuls
//////////////////////////////////////////////////////////////////////////
    wire [`DWIDTH-1:0] a0;
    wire [`DWIDTH-1:0] a1;
    wire [`DWIDTH-1:0] a2;
    wire [`DWIDTH-1:0] a3;
    wire [`DWIDTH-1:0] b0;
    wire [`DWIDTH-1:0] b1;
    wire [`DWIDTH-1:0] b2;
    wire [`DWIDTH-1:0] b3;
    
    wire [`DWIDTH-1:0] a0_data_in;
    wire [`DWIDTH-1:0] a1_data_in;
    wire [`DWIDTH-1:0] a2_data_in;
    wire [`DWIDTH-1:0] a3_data_in;
    assign a0_data_in = a_data_in[`DWIDTH-1:0];
    assign a1_data_in = a_data_in[2*`DWIDTH-1:`DWIDTH];
    assign a2_data_in = a_data_in[3*`DWIDTH-1:2*`DWIDTH];
    assign a3_data_in = a_data_in[4*`DWIDTH-1:3*`DWIDTH];
    
    wire [`DWIDTH-1:0] b0_data_in;
    wire [`DWIDTH-1:0] b1_data_in;
    wire [`DWIDTH-1:0] b2_data_in;
    wire [`DWIDTH-1:0] b3_data_in;
    assign b0_data_in = b_data_in[`DWIDTH-1:0];
    assign b1_data_in = b_data_in[2*`DWIDTH-1:`DWIDTH];
    assign b2_data_in = b_data_in[3*`DWIDTH-1:2*`DWIDTH];
    assign b3_data_in = b_data_in[4*`DWIDTH-1:3*`DWIDTH];
    
    //If b_loc is 0, that means this matmul block is on the top-row of the
    //final large matmul. In that case, b will take inputs from mem.
    //If b_loc != 0, that means this matmul block is not on the top-row of the
    //final large matmul. In that case, b will take inputs from the matmul on top
    //of this one.
    assign a0 = (b_loc==0) ? a0_data           : a0_data_in;
    assign a1 = (b_loc==0) ? a1_data_delayed_1 : a1_data_in;
    assign a2 = (b_loc==0) ? a2_data_delayed_2 : a2_data_in;
    assign a3 = (b_loc==0) ? a3_data_delayed_3 : a3_data_in;

    //If a_loc is 0, that means this matmul block is on the left-col of the
    //final large matmul. In that case, a will take inputs from mem.
    //If a_loc != 0, that means this matmul block is not on the left-col of the
    //final large matmul. In that case, a will take inputs from the matmul on left
    //of this one.
    assign b0 = (a_loc==0) ? b0_data           : b0_data_in;
    assign b1 = (a_loc==0) ? b1_data_delayed_1 : b1_data_in;
    assign b2 = (a_loc==0) ? b2_data_delayed_2 : b2_data_in;
    assign b3 = (a_loc==0) ? b3_data_delayed_3 : b3_data_in;
    

    wire [`DWIDTH-1:0] matrixC00;
    wire [`DWIDTH-1:0] matrixC01;
    wire [`DWIDTH-1:0] matrixC02;
    wire [`DWIDTH-1:0] matrixC03;
    wire [`DWIDTH-1:0] matrixC10;
    wire [`DWIDTH-1:0] matrixC11;
    wire [`DWIDTH-1:0] matrixC12;
    wire [`DWIDTH-1:0] matrixC13;
    wire [`DWIDTH-1:0] matrixC20;
    wire [`DWIDTH-1:0] matrixC21;
    wire [`DWIDTH-1:0] matrixC22;
    wire [`DWIDTH-1:0] matrixC23;
    wire [`DWIDTH-1:0] matrixC30;
    wire [`DWIDTH-1:0] matrixC31;
    wire [`DWIDTH-1:0] matrixC32;
    wire [`DWIDTH-1:0] matrixC33;
    

//////////////////////////////////////////////////////////////////////////
// Instantiation of the output logic
//////////////////////////////////////////////////////////////////////////
    output_logic u_output_logic(
        .clk(clk),
        .reset(reset),
        .start_mat_mul(start_mat_mul),
        .done_mat_mul(done_mat_mul),
        .address_mat_c(address_mat_c),
        .address_stride_c(address_stride_c),
        .c_data_out(c_data_out),
        .c_data_in(c_data_in),
        .c_addr(c_addr),
        .c_data_available(c_data_available),
        .clk_cnt(clk_cnt),
        .row_latch_en(row_latch_en),
        .final_mat_mul_size(final_mat_mul_size),
        .matrixC00(matrixC00),
        .matrixC01(matrixC01),
        .matrixC02(matrixC02),
        .matrixC03(matrixC03),
        .matrixC10(matrixC10),
        .matrixC11(matrixC11),
        .matrixC12(matrixC12),
        .matrixC13(matrixC13),
        .matrixC20(matrixC20),
        .matrixC21(matrixC21),
        .matrixC22(matrixC22),
        .matrixC23(matrixC23),
        .matrixC30(matrixC30),
        .matrixC31(matrixC31),
        .matrixC32(matrixC32),
        .matrixC33(matrixC33)
        );

//////////////////////////////////////////////////////////////////////////
// Instantiations of the actual PEs
//////////////////////////////////////////////////////////////////////////
    systolic_pe_matrix u_systolic_pe_matrix(
        .reset(reset),
        .clk(clk),
        .pe_reset(pe_reset),
        .start_mat_mul(start_mat_mul),
        .a0(a0), 
        .a1(a1), 
        .a2(a2), 
        .a3(a3),
        .b0(b0), 
        .b1(b1), 
        .b2(b2), 
        .b3(b3),
        .matrixC00(matrixC00),
        .matrixC01(matrixC01),
        .matrixC02(matrixC02),
        .matrixC03(matrixC03),
        .matrixC10(matrixC10),
        .matrixC11(matrixC11),
        .matrixC12(matrixC12),
        .matrixC13(matrixC13),
        .matrixC20(matrixC20),
        .matrixC21(matrixC21),
        .matrixC22(matrixC22),
        .matrixC23(matrixC23),
        .matrixC30(matrixC30),
        .matrixC31(matrixC31),
        .matrixC32(matrixC32),
        .matrixC33(matrixC33),
        .a_data_out(a_data_out),
        .b_data_out(b_data_out)
        );

endmodule

//////////////////////////////////////////////////////////////////////////
// Output logic
//////////////////////////////////////////////////////////////////////////
module output_logic(
    clk,
    reset,
    start_mat_mul,
    done_mat_mul,
    address_mat_c,
    address_stride_c,
    c_data_in,
    c_data_out, //Data values going out to next matmul - systolic shifting
    c_addr,
    c_data_available,
    clk_cnt,
    row_latch_en,
    final_mat_mul_size,
    matrixC00,
    matrixC01,
    matrixC02,
    matrixC03,
    matrixC10,
    matrixC11,
    matrixC12,
    matrixC13,
    matrixC20,
    matrixC21,
    matrixC22,
    matrixC23,
    matrixC30,
    matrixC31,
    matrixC32,
    matrixC33
    );

    input clk;
    input reset;
    input start_mat_mul;
    input done_mat_mul;
    input [`AWIDTH-1:0] address_mat_c;
    input [`ADDR_STRIDE_WIDTH-1:0] address_stride_c;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_in;
    output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_out;
    output [`AWIDTH-1:0] c_addr;
    output c_data_available;
    input [7:0] clk_cnt;
    output row_latch_en;
    input [7:0] final_mat_mul_size;
    input [`DWIDTH-1:0] matrixC00;
    input [`DWIDTH-1:0] matrixC01;
    input [`DWIDTH-1:0] matrixC02;
    input [`DWIDTH-1:0] matrixC03;
    input [`DWIDTH-1:0] matrixC10;
    input [`DWIDTH-1:0] matrixC11;
    input [`DWIDTH-1:0] matrixC12;
    input [`DWIDTH-1:0] matrixC13;
    input [`DWIDTH-1:0] matrixC20;
    input [`DWIDTH-1:0] matrixC21;
    input [`DWIDTH-1:0] matrixC22;
    input [`DWIDTH-1:0] matrixC23;
    input [`DWIDTH-1:0] matrixC30;
    input [`DWIDTH-1:0] matrixC31;
    input [`DWIDTH-1:0] matrixC32;
    input [`DWIDTH-1:0] matrixC33;
    
    wire row_latch_en;

//////////////////////////////////////////////////////////////////////////
// Logic to capture matrix C data from the PEs and shift it out
//////////////////////////////////////////////////////////////////////////
    assign row_latch_en = ((clk_cnt == ((final_mat_mul_size<<2) - final_mat_mul_size -1 +`NUM_CYCLES_IN_MAC)));
    
    reg c_data_available;
    reg [`AWIDTH-1:0] c_addr;
    reg start_capturing_c_data;
    integer counter;
    reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_out;
    reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_out_1;
    reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_out_2;
    reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_out_3;
    
    wire [`MAT_MUL_SIZE*`DWIDTH-1:0] col0;
    wire [`MAT_MUL_SIZE*`DWIDTH-1:0] col1;
    wire [`MAT_MUL_SIZE*`DWIDTH-1:0] col2;
    wire [`MAT_MUL_SIZE*`DWIDTH-1:0] col3;
    assign col0 = {matrixC30, matrixC20, matrixC10, matrixC00};
    assign col1 = {matrixC31, matrixC21, matrixC11, matrixC01};
    assign col2 = {matrixC32, matrixC22, matrixC12, matrixC02};
    assign col3 = {matrixC33, matrixC23, matrixC13, matrixC03};

//If save_output_to_accum is asserted, that means we are not intending to shift
//out the outputs, because the outputs are still partial sums. 
    wire condition_to_start_shifting_output;
    assign condition_to_start_shifting_output = row_latch_en ;  

//For larger matmuls, this logic will have more entries in the case statement
    always @(posedge clk) 
    begin
        if (reset | ~start_mat_mul) 
        begin
            start_capturing_c_data <= 1'b0;
            c_data_available <= 1'b0;
            c_addr <= address_mat_c - address_stride_c;
            c_data_out <= 0;
            counter <= 0;
            c_data_out_1 <= 0; 
            c_data_out_2 <= 0; 
            c_data_out_3 <= 0; 
        end
        else if (condition_to_start_shifting_output) 
        begin
            start_capturing_c_data <= 1'b1;
            c_data_available <= 1'b1;
            c_addr <= c_addr + address_stride_c;
            c_data_out <= col0; 
            c_data_out_1 <= col1; 
            c_data_out_2 <= col2; 
            c_data_out_3 <= col3; 
            counter <= counter + 1;
        end 
        else if (done_mat_mul) 
        begin
            start_capturing_c_data <= 1'b0;
            c_data_available <= 1'b0;
            c_addr <= address_mat_c+address_stride_c;
            c_data_out <= 0;
            c_data_out_1 <= 0;
            c_data_out_2 <= 0;
            c_data_out_3 <= 0;
        end 
        else if (counter >= `MAT_MUL_SIZE) 
        begin
            c_addr <= c_addr + address_stride_c;
            c_data_out <= c_data_out_1;
            c_data_out_1 <= c_data_out_2;
            c_data_out_2 <= c_data_out_3;
            c_data_out_3 <= c_data_in;
        end
        else if (start_capturing_c_data) 
        begin
            c_data_available <= 1'b1;
            c_addr <= c_addr + address_stride_c;
            counter <= counter + 1;
            c_data_out <= c_data_out_1;
            c_data_out_1 <= c_data_out_2;
            c_data_out_2 <= c_data_out_3;
            c_data_out_3 <= c_data_in;
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////
// Systolic data setup
//////////////////////////////////////////////////////////////////////////
module systolic_data_setup(
    clk,
    reset,
    start_mat_mul,
    a_addr,
    b_addr,
    address_mat_a,
    address_mat_b,
    address_stride_a,
    address_stride_b,
    a_data,
    b_data,
    clk_cnt,
    a0_data,
    a1_data_delayed_1,
    a2_data_delayed_2,
    a3_data_delayed_3,
    b0_data,
    b1_data_delayed_1,
    b2_data_delayed_2,
    b3_data_delayed_3,
    validity_mask_a_rows,
    validity_mask_a_cols_b_rows,
    validity_mask_b_cols,
    final_mat_mul_size,
    a_loc,
    b_loc
    );

    input clk;
    input reset;
    input start_mat_mul;
    output [`AWIDTH-1:0] a_addr;
    output [`AWIDTH-1:0] b_addr;
    input [`AWIDTH-1:0] address_mat_a;
    input [`AWIDTH-1:0] address_mat_b;
    input [`ADDR_STRIDE_WIDTH-1:0] address_stride_a;
    input [`ADDR_STRIDE_WIDTH-1:0] address_stride_b;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data;
    input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data;
    input [7:0] clk_cnt;
    output [`DWIDTH-1:0] a0_data;
    output [`DWIDTH-1:0] a1_data_delayed_1;
    output [`DWIDTH-1:0] a2_data_delayed_2;
    output [`DWIDTH-1:0] a3_data_delayed_3;
    output [`DWIDTH-1:0] b0_data;
    output [`DWIDTH-1:0] b1_data_delayed_1;
    output [`DWIDTH-1:0] b2_data_delayed_2;
    output [`DWIDTH-1:0] b3_data_delayed_3;
    input [`MASK_WIDTH-1:0] validity_mask_a_rows;
    input [`MASK_WIDTH-1:0] validity_mask_a_cols_b_rows;
    input [`MASK_WIDTH-1:0] validity_mask_b_cols;
    input [7:0] final_mat_mul_size;
    input [7:0] a_loc;
    input [7:0] b_loc;
    
    wire [`DWIDTH-1:0] a0_data;
    wire [`DWIDTH-1:0] a1_data;
    wire [`DWIDTH-1:0] a2_data;
    wire [`DWIDTH-1:0] a3_data;
    wire [`DWIDTH-1:0] b0_data;
    wire [`DWIDTH-1:0] b1_data;
    wire [`DWIDTH-1:0] b2_data;
    wire [`DWIDTH-1:0] b3_data;

//////////////////////////////////////////////////////////////////////////
// Logic to generate addresses to BRAM A
//////////////////////////////////////////////////////////////////////////
    reg [`AWIDTH-1:0] a_addr;
    reg a_mem_access; //flag that tells whether the matmul is trying to access memory or not
    
    always @(posedge clk) 
    begin
        if ((reset || ~start_mat_mul) || (clk_cnt >= (a_loc<<`LOG2_MAT_MUL_SIZE)+final_mat_mul_size)) begin
            a_addr <= address_mat_a-address_stride_a;
            a_mem_access <= 0;
        end
        else if ((clk_cnt >= (a_loc<<`LOG2_MAT_MUL_SIZE)) && (clk_cnt < (a_loc<<`LOG2_MAT_MUL_SIZE)+final_mat_mul_size)) 
        begin
            a_addr <= a_addr + address_stride_a;
            a_mem_access <= 1;
        end
    end  

//////////////////////////////////////////////////////////////////////////
// Logic to generate valid signals for data coming from BRAM A
//////////////////////////////////////////////////////////////////////////
    reg [7:0] a_mem_access_counter;
    always @(posedge clk) 
    begin
        if (reset || ~start_mat_mul) 
            a_mem_access_counter <= 0;
        else if (a_mem_access == 1) 
            a_mem_access_counter <= a_mem_access_counter + 1;  
        else 
            a_mem_access_counter <= 0;
    end

    wire a_data_valid; //flag that tells whether the data from memory is valid
    assign a_data_valid = 
        ((validity_mask_a_cols_b_rows[0]==1'b0 && a_mem_access_counter==1) ||
        (validity_mask_a_cols_b_rows[1]==1'b0 && a_mem_access_counter==2) ||
        (validity_mask_a_cols_b_rows[2]==1'b0 && a_mem_access_counter==3) ||
        (validity_mask_a_cols_b_rows[3]==1'b0 && a_mem_access_counter==4)) ?
        1'b0 : (a_mem_access_counter >= `MEM_ACCESS_LATENCY);
    
//////////////////////////////////////////////////////////////////////////
// Logic to delay certain parts of the data received from BRAM A (systolic data setup)
//////////////////////////////////////////////////////////////////////////
//Slice data into chunks and qualify it with whether it is valid or not
    assign a0_data = a_data[`DWIDTH-1:0] & {`DWIDTH{a_data_valid}} & {`DWIDTH{validity_mask_a_rows[0]}};
    assign a1_data = a_data[2*`DWIDTH-1:`DWIDTH] & {`DWIDTH{a_data_valid}} & {`DWIDTH{validity_mask_a_rows[1]}};
    assign a2_data = a_data[3*`DWIDTH-1:2*`DWIDTH] & {`DWIDTH{a_data_valid}} & {`DWIDTH{validity_mask_a_rows[2]}};
    assign a3_data = a_data[4*`DWIDTH-1:3*`DWIDTH] & {`DWIDTH{a_data_valid}} & {`DWIDTH{validity_mask_a_rows[3]}};

//For larger matmuls, more such delaying flops will be needed
    reg [`DWIDTH-1:0] a1_data_delayed_1;
    reg [`DWIDTH-1:0] a2_data_delayed_1;
    reg [`DWIDTH-1:0] a2_data_delayed_2;
    reg [`DWIDTH-1:0] a3_data_delayed_1;
    reg [`DWIDTH-1:0] a3_data_delayed_2;
    reg [`DWIDTH-1:0] a3_data_delayed_3;
    
    always @(posedge clk) 
    begin
        if (reset || ~start_mat_mul || clk_cnt==0) 
        begin
            a1_data_delayed_1 <= 0;
            a2_data_delayed_1 <= 0;
            a2_data_delayed_2 <= 0;
            a3_data_delayed_1 <= 0;
            a3_data_delayed_2 <= 0;
            a3_data_delayed_3 <= 0;
        end
        else 
        begin
            a1_data_delayed_1 <= a1_data;
            a2_data_delayed_1 <= a2_data;
            a2_data_delayed_2 <= a2_data_delayed_1;
            a3_data_delayed_1 <= a3_data;
            a3_data_delayed_2 <= a3_data_delayed_1;
            a3_data_delayed_3 <= a3_data_delayed_2;
        end
    end

//////////////////////////////////////////////////////////////////////////
// Logic to generate addresses to BRAM B
//////////////////////////////////////////////////////////////////////////
    reg [`AWIDTH-1:0] b_addr;
    reg b_mem_access; //flag that tells whether the matmul is trying to access memory or not

    always @(posedge clk) 
    begin
        if ((reset || ~start_mat_mul) || (clk_cnt >= (b_loc<<`LOG2_MAT_MUL_SIZE)+final_mat_mul_size)) 
        begin
            b_addr <= address_mat_b - address_stride_b;
            b_mem_access <= 0;
        end
        else if ((clk_cnt >= (b_loc<<`LOG2_MAT_MUL_SIZE)) && (clk_cnt < (b_loc<<`LOG2_MAT_MUL_SIZE)+final_mat_mul_size)) 
        begin
            b_addr <= b_addr + address_stride_b;
            b_mem_access <= 1;
        end
    end  

//////////////////////////////////////////////////////////////////////////
// Logic to generate valid signals for data coming from BRAM B
//////////////////////////////////////////////////////////////////////////
    reg [7:0] b_mem_access_counter;
    always @(posedge clk) 
    begin
        if (reset || ~start_mat_mul) 
            b_mem_access_counter <= 0;
        else if (b_mem_access == 1)
            b_mem_access_counter <= b_mem_access_counter + 1;  
        else
            b_mem_access_counter <= 0;
    end

    wire b_data_valid; //flag that tells whether the data from memory is valid
    assign b_data_valid = 
        ((validity_mask_a_cols_b_rows[0]==1'b0 && b_mem_access_counter==1) ||
        (validity_mask_a_cols_b_rows[1]==1'b0 && b_mem_access_counter==2) ||
        (validity_mask_a_cols_b_rows[2]==1'b0 && b_mem_access_counter==3) ||
        (validity_mask_a_cols_b_rows[3]==1'b0 && b_mem_access_counter==4)) ?
        1'b0 : (b_mem_access_counter >= `MEM_ACCESS_LATENCY);


//////////////////////////////////////////////////////////////////////////
// Logic to delay certain parts of the data received from BRAM B (systolic data setup)
//////////////////////////////////////////////////////////////////////////
//Slice data into chunks and qualify it with whether it is valid or not
    assign b0_data = b_data[`DWIDTH-1:0] & {`DWIDTH{b_data_valid}} & {`DWIDTH{validity_mask_b_cols[0]}};
    assign b1_data = b_data[2*`DWIDTH-1:`DWIDTH] & {`DWIDTH{b_data_valid}} & {`DWIDTH{validity_mask_b_cols[1]}};
    assign b2_data = b_data[3*`DWIDTH-1:2*`DWIDTH] & {`DWIDTH{b_data_valid}} & {`DWIDTH{validity_mask_b_cols[2]}};
    assign b3_data = b_data[4*`DWIDTH-1:3*`DWIDTH] & {`DWIDTH{b_data_valid}} & {`DWIDTH{validity_mask_b_cols[3]}};

//For larger matmuls, more such delaying flops will be needed
    reg [`DWIDTH-1:0] b1_data_delayed_1;
    reg [`DWIDTH-1:0] b2_data_delayed_1;
    reg [`DWIDTH-1:0] b2_data_delayed_2;
    reg [`DWIDTH-1:0] b3_data_delayed_1;
    reg [`DWIDTH-1:0] b3_data_delayed_2;
    reg [`DWIDTH-1:0] b3_data_delayed_3;
    
    always @(posedge clk) 
    begin
        if (reset || ~start_mat_mul || clk_cnt==0) 
        begin
            b1_data_delayed_1 <= 0;
            b2_data_delayed_1 <= 0;
            b2_data_delayed_2 <= 0;
            b3_data_delayed_1 <= 0;
            b3_data_delayed_2 <= 0;
            b3_data_delayed_3 <= 0;
        end
        else 
        begin
            b1_data_delayed_1 <= b1_data;
            b2_data_delayed_1 <= b2_data;
            b2_data_delayed_2 <= b2_data_delayed_1;
            b3_data_delayed_1 <= b3_data;
            b3_data_delayed_2 <= b3_data_delayed_1;
            b3_data_delayed_3 <= b3_data_delayed_2;
        end
    end

endmodule



//////////////////////////////////////////////////////////////////////////
// Systolically connected PEs
//////////////////////////////////////////////////////////////////////////
module systolic_pe_matrix(
    reset,
    clk,
    pe_reset,
    start_mat_mul,
    a0, a1, a2, a3,
    b0, b1, b2, b3,
    matrixC00,
    matrixC01,
    matrixC02,
    matrixC03,
    matrixC10,
    matrixC11,
    matrixC12,
    matrixC13,
    matrixC20,
    matrixC21,
    matrixC22,
    matrixC23,
    matrixC30,
    matrixC31,
    matrixC32,
    matrixC33,
    a_data_out,
    b_data_out
    );

    input clk;
    input reset;
    input pe_reset;
    input start_mat_mul;
    input [`DWIDTH-1:0] a0;
    input [`DWIDTH-1:0] a1;
    input [`DWIDTH-1:0] a2;
    input [`DWIDTH-1:0] a3;
    input [`DWIDTH-1:0] b0;
    input [`DWIDTH-1:0] b1;
    input [`DWIDTH-1:0] b2;
    input [`DWIDTH-1:0] b3;
    output [`DWIDTH-1:0] matrixC00;
    output [`DWIDTH-1:0] matrixC01;
    output [`DWIDTH-1:0] matrixC02;
    output [`DWIDTH-1:0] matrixC03;
    output [`DWIDTH-1:0] matrixC10;
    output [`DWIDTH-1:0] matrixC11;
    output [`DWIDTH-1:0] matrixC12;
    output [`DWIDTH-1:0] matrixC13;
    output [`DWIDTH-1:0] matrixC20;
    output [`DWIDTH-1:0] matrixC21;
    output [`DWIDTH-1:0] matrixC22;
    output [`DWIDTH-1:0] matrixC23;
    output [`DWIDTH-1:0] matrixC30;
    output [`DWIDTH-1:0] matrixC31;
    output [`DWIDTH-1:0] matrixC32;
    output [`DWIDTH-1:0] matrixC33;
    output [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_out;
    output [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_out;

    wire [`DWIDTH-1:0] a00to01, a01to02, a02to03, a03to04;
    wire [`DWIDTH-1:0] a10to11, a11to12, a12to13, a13to14;
    wire [`DWIDTH-1:0] a20to21, a21to22, a22to23, a23to24;
    wire [`DWIDTH-1:0] a30to31, a31to32, a32to33, a33to34;
    
    wire [`DWIDTH-1:0] b00to10, b10to20, b20to30, b30to40; 
    wire [`DWIDTH-1:0] b01to11, b11to21, b21to31, b31to41;
    wire [`DWIDTH-1:0] b02to12, b12to22, b22to32, b32to42;
    wire [`DWIDTH-1:0] b03to13, b13to23, b23to33, b33to43;
    
    wire effective_rst;
    assign effective_rst = reset | pe_reset;
    
    //FILL IN REST OF THE CODE (x)
    //There are a total of 16 PEs arranged in a mesh structure like in the lecture slides. 	
	//Each PE has a number. PE00 is the top-left PE. PE01 is the second PE on the first row. 
	//PE10 is the first PE on the second row. PE33 is the bottom right PE.	
    //Signals a0, a1, a2, a3 are coming from matrix A. They need to be be connected to the first column of PEs.
	//b0, b1, b2, b3 signals are coming from matrix B. They need to be connected to the first row of the PEs.
	//Signals axytozw go from PExy to PEzw horizontally.
	//Signals bxytozw go from PExy to PEzw vertically.
	//Signals matrixCxx are the output results from each PE.
	//Reset and clock signals of all PEs are the same.
	//Three of them are connected below. Connect the others properly.
    processing_element pe00(.reset(effective_rst), .clk(clk),  .in_a(a0),      	.in_b(b0),  	.out_a(a00to01), .out_b(b00to10), .out_c(matrixC00));
    processing_element pe10(.reset(effective_rst), .clk(clk),  .in_a(a00to01),      .in_b(b1),     .out_a(a10to11), .out_b(b10to20), .out_c(matrixC10));
    processing_element pe20(.reset(effective_rst), .clk(clk),  .in_a(a10to11),      .in_b(b2),     .out_a(a20to21), .out_b(b20to30), .out_c(matrixC20));
    processing_element pe30(.reset(effective_rst), .clk(clk),  .in_a(a20to21),      .in_b(b3),     .out_a(a30to31), .out_b(b30to40), .out_c(matrixC30));
    
    processing_element pe01(.reset(effective_rst), .clk(clk),  .in_a(a1),         .in_b(b00to10),  .out_a(a01to02), .out_b(b01to11), .out_c(matrixC01));
    processing_element pe11(.reset(effective_rst), .clk(clk),  .in_a(a01to02),      .in_b(b10to20),    .out_a(a11to12), .out_b(b11to21), .out_c(matrixC11));
    processing_element pe21(.reset(effective_rst), .clk(clk),  .in_a(a11to12),      .in_b(b20to30), .out_a(a21to22), .out_b(b21to31), .out_c(matrixC21));
    processing_element pe31(.reset(effective_rst), .clk(clk),  .in_a(a21to22),       .in_b(b30to40), .out_a(a31to32), .out_b(b31to41), .out_c(matrixC31));
    
    processing_element pe02(.reset(effective_rst), .clk(clk),  .in_a(a2),         .in_b(b01to11),  .out_a(a02to03), .out_b(b02to12), .out_c(matrixC02));
    processing_element pe12(.reset(effective_rst), .clk(clk),  .in_a(a02to03),      .in_b(b11to21), .out_a(a12to13), .out_b(b12to22), .out_c(matrixC12));
    processing_element pe22(.reset(effective_rst), .clk(clk),  .in_a(a12to13),      .in_b(b21to31), .out_a(a22to23), .out_b(b22to32), .out_c(matrixC22));
    processing_element pe32(.reset(effective_rst), .clk(clk),  .in_a(a22to23),      .in_b(b31to41), .out_a(a32to33), .out_b(b32to42), .out_c(matrixC32));
    
    processing_element pe03(.reset(effective_rst), .clk(clk),  .in_a(a3),         .in_b(b02to12),  .out_a(a03to04), .out_b(b03to13), .out_c(matrixC03));
    processing_element pe13(.reset(effective_rst), .clk(clk),  .in_a(a03to04),      .in_b(b12to22),  .out_a(a13to14), .out_b(b13to23), .out_c(matrixC13));
    processing_element pe23(.reset(effective_rst), .clk(clk),  .in_a(a13to14),      .in_b(b22to32),  .out_a(a23to24), .out_b(b23to33), .out_c(matrixC23));
    processing_element pe33(.reset(effective_rst), .clk(clk),  .in_a(a23to24),       .in_b(b32to42), .out_a(a33to34), .out_b(b33to43), .out_c(matrixC33));
    assign a_data_out = {a33to34,a23to24,a13to14,a03to04};
    assign b_data_out = {b33to43,b32to42,b31to41,b30to40};

endmodule


//////////////////////////////////////////////////////////////////////////
// Processing element (PE)
//////////////////////////////////////////////////////////////////////////
module processing_element(
    reset, 
    clk, 
    in_a,
    in_b, 
    out_a, 
    out_b, 
    out_c
    );

    input reset;
    input clk;
    input  [`DWIDTH-1:0] in_a;
    input  [`DWIDTH-1:0] in_b;
    output [`DWIDTH-1:0] out_a;
    output [`DWIDTH-1:0] out_b;
    output [`DWIDTH-1:0] out_c;  //reduced precision

    reg [`DWIDTH-1:0] out_a;
    reg [`DWIDTH-1:0] out_b;
    wire [`DWIDTH-1:0] out_c;
    wire [`DWIDTH-1:0] out_mac;

    assign out_c = out_mac;
    
    seq_mac u_mac(.a(in_a), .b(in_b), .out(out_mac), .reset(reset), .clk(clk));

    always @(posedge clk)
    begin
        if(reset) 
        begin
            out_a<=0;
            out_b<=0;
        end
        else 
        begin  
            out_a<=in_a;
            out_b<=in_b;
        end
    end
 
endmodule

//////////////////////////////////////////////////////////////////////////
// Multiply-and-accumulate (MAC) block
//////////////////////////////////////////////////////////////////////////
//The following line forces the synthesis tool to use a DSP for this MAC operation
(* use_dsp="yes" *)
module seq_mac(a, b, out, reset, clk);
    input [`DWIDTH-1:0] a;
    input [`DWIDTH-1:0] b;
    input reset;
    input clk;
    output [`DWIDTH-1:0] out;

    reg [`DWIDTH-1:0] out;
    reg [`DWIDTH-1:0] a_flop, b_flop, mult;

    always @(posedge clk)
    begin
        if(reset)
        begin
            out <= 0;
            a_flop <= 0;
            b_flop <= 0;
            mult <= 0;
        end
        else
        begin
            a_flop <= a;
            b_flop <= b;
            mult <= a_flop * b_flop;
            out <= mult + out;
        end
            
    end

endmodule
