//If you have trouble finding where to complete the code
//Do Ctrl+F "FILL IN"

`timescale 1ns/1ns
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

//Design with memories
module matrix_multiplication(
  clk, 
  resetn, 
  pe_resetn,
  address_mat_a,
  address_mat_b,
  address_mat_c,
  address_stride_a,
  address_stride_b,
  address_stride_c,
  validity_mask_a_rows,
  validity_mask_a_cols_b_rows,
  validity_mask_b_cols,
  bram_addr_a_ext,
  bram_we_a_ext,
  bram_addr_b_ext,
  bram_we_b_ext,
  bram_addr_c_ext,
  bram_we_c_ext,
  start_reg,
  clear_done_reg,
  bram_wdata,
  bram_rdata,
  mem_sel
);

	input clk;
	input resetn;
	input pe_resetn;
	input [`AWIDTH-1:0] address_mat_a;
	input [`AWIDTH-1:0] address_mat_b;
	input [`AWIDTH-1:0] address_mat_c;
	input [`ADDR_STRIDE_WIDTH-1:0] address_stride_a;
	input [`ADDR_STRIDE_WIDTH-1:0] address_stride_b;
	input [`ADDR_STRIDE_WIDTH-1:0] address_stride_c;
	input [`MASK_WIDTH-1:0] validity_mask_a_rows;
	input [`MASK_WIDTH-1:0] validity_mask_a_cols_b_rows;
	input [`MASK_WIDTH-1:0] validity_mask_b_cols;
	input  [`AWIDTH-1:0] bram_addr_a_ext;
	input  [`MASK_WIDTH-1:0] bram_we_a_ext;
	input  [`AWIDTH-1:0] bram_addr_b_ext;
	input  [`MASK_WIDTH-1:0] bram_we_b_ext;
	input  [`AWIDTH-1:0] bram_addr_c_ext;
	input  [`MASK_WIDTH-1:0] bram_we_c_ext;
	input  [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata;
	output [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata;
	input [1:0] mem_sel;
	input start_reg;
	input clear_done_reg;
  
	wire [`AWIDTH-1:0] bram_addr_a;
	wire [4*`DWIDTH-1:0] bram_rdata_a;
	wire [4*`DWIDTH-1:0] bram_wdata_a;
	wire [`MASK_WIDTH-1:0] bram_we_a;
	wire bram_en_a;

	wire [`AWIDTH-1:0] bram_addr_b;
	wire [4*`DWIDTH-1:0] bram_rdata_b;
	wire [4*`DWIDTH-1:0] bram_wdata_b;
	wire [`MASK_WIDTH-1:0] bram_we_b;
	wire bram_en_b;
	
	wire [`AWIDTH-1:0] bram_addr_c;
	wire [4*`DWIDTH-1:0] bram_rdata_c;
	wire [4*`DWIDTH-1:0] bram_wdata_c;
	wire [`MASK_WIDTH-1:0] bram_we_c;
	wire bram_en_c;
	
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_wdata_a_ext, bram_wdata_b_ext, bram_wdata_c_ext;
	wire [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata_a_ext, bram_rdata_b_ext, bram_rdata_c_ext; 
	reg [`MAT_MUL_SIZE*`DWIDTH-1:0] bram_rdata;

    reg [3:0] state;
    
    //Reduce I/O usage, used to be 151% util before rework
    always @ (*)
    begin
    if(mem_sel == 0)
    begin
        bram_wdata_a_ext = bram_wdata;
    end
    else if(mem_sel == 1)
    begin
        bram_wdata_b_ext = bram_wdata;
    end
    else
    begin
        bram_wdata_c_ext = bram_wdata;
    end
    end
    
    always @ (*)
    begin
    if(mem_sel == 0)
    begin
        bram_rdata = bram_rdata_a_ext;
    end
    else if(mem_sel == 1)
    begin
        bram_rdata = bram_rdata_b_ext;
    end
    else
    begin
        bram_rdata = bram_rdata_c_ext;
    end
    end

    //FILL IN THE CODE (x)
    //We will utilize port 0 (addr0, d0, we0, q0) to interface with the matmul.
    //Unused ports (port 1 signals addr1, d1, we1, q1) will be connected to the "external" signals i.e. signals that exposed to the external world.
    //You are only allowed to use declared ports that begin with "bram_".
	//Signals that are external end in "_ext".
    //addr is the address of the BRAM, d is the data to be written to the BRAM, we is write enable, and q is the data read from the BRAM. 
    ////////////////////////////////////////////////////////////////
    // BRAM matrix A 
    ////////////////////////////////////////////////////////////////
//    ram matrix_A (x);
    ram matrix_A (
    .addr0(bram_addr_a), // Address input connected to port 0
    .d0(bram_wdata_a), // Data input connected to port 0
    .we0(bram_we_a), // Write enable input connected to port 0
    .q0(bram_rdata_a), // Data output connected to port 0
    .addr1(bram_addr_a_ext), // Address input connected to port 1 (external)
    .d1(bram_wdata_a_ext), // Data input connected to port 1 (external)
    .we1(bram_we_a_ext), // Write enable input connected to port 1 (external)
    .q1(bram_rdata_a_ext), // Data output connected to port 1 (external)
    .clk(clk) // Clock input
);
    ////////////////////////////////////////////////////////////////
    // BRAM matrix B 
    ////////////////////////////////////////////////////////////////
//    ram matrix_B (x);
    ram matrix_B (
    .addr0(bram_addr_b), // Address input connected to port 0
    .d0(bram_wdata_b), // Data input connected to port 0
    .we0(bram_we_b), // Write enable input connected to port 0
    .q0(bram_rdata_b), // Data output connected to port 0
    .addr1(bram_addr_b_ext), // Address input connected to port 1 (external)
    .d1(bram_wdata_b_ext), // Data input connected to port 1 (external)
    .we1(bram_we_b_ext), // Write enable input connected to port 1 (external)
    .q1(bram_rdata_b_ext), // Data output connected to port 1 (external)
    .clk(clk) // Clock input
);
    ////////////////////////////////////////////////////////////////
    // BRAM matrix C 
    ////////////////////////////////////////////////////////////////
//    ram matrix_C (x);
ram matrix_C (
    .addr0(bram_addr_c), // Address input connected to port 0
    .d0(bram_wdata_c), // Data input connected to port 0
    .we0(bram_we_c), // Write enable input connected to port 0
    .q0(bram_rdata_c), // Data output connected to port 0
    .addr1(bram_addr_c_ext), // Address input connected to port 1 (external)
    .d1(bram_wdata_c_ext), // Data input connected to port 1 (external)
    .we1(bram_we_c_ext), // Write enable input connected to port 1 (external)
    .q1(bram_rdata_c_ext), // Data output connected to port 1 (external)
    .clk(clk) // Clock input
);

    reg start_mat_mul;
    wire done_mat_mul;
	
	//fsm to start matmul
	always @( posedge clk) 
	begin
        if (resetn == 1'b0) 
        begin
            state <= 4'b0000;
            start_mat_mul <= 1'b0;
        end 
        else 
        begin
            case (state)
            4'b0000: 
            begin
                start_mat_mul <= 1'b0;
                if (start_reg == 1'b1) 
                    state <= 4'b0001;
                else 
                    state <= 4'b0000;
            end
            
            4'b0001: 
            begin
                start_mat_mul <= 1'b1;	      
                state <= 4'b1010;                    
            end      
            
            
            4'b1010: 
            begin                 
                if (done_mat_mul == 1'b1) 
                begin
                    start_mat_mul <= 1'b0;
                    state <= 4'b1000;
                end
                else 
                    state <= 4'b1010;
            end
            
            4'b1000: 
            begin
                if (clear_done_reg == 1'b1) 
                    state <= 4'b0000;
                else 
                    state <= 4'b1000;
            end
            
            default:
                state <= 4'b0000;
            endcase  
        end 
    end

    wire c_data_available;

//Connections for bram c (output matrix)
//bram_addr_c -> connected to u_matmul_4x4 block
//bram_rdata_c -> not used
//bram_wdata_c -> connected to u_matmul_4x4 block
//bram_we_c -> set to 1 when c_data is available

    assign bram_we_c = (c_data_available) ? 4'b1111 : 4'b0000;  

//Connections for bram a (first input matrix)
//bram_addr_a -> connected to u_matmul_4x4
//bram_rdata_a -> connected to u_matmul_4x4
//bram_wdata_a -> hardcoded to 0 (this block only reads from bram a)
//bram_we_a -> hardcoded to 0 (this block only reads from bram a)

    assign bram_wdata_a = 32'b0;
    assign bram_we_a = 4'b0;
  
//Connections for bram b (second input matrix)
//bram_addr_b -> connected to u_matmul_4x4
//bram_rdata_b -> connected to u_matmul_4x4
//bram_wdata_b -> hardcoded to 0 (this block only reads from bram b)
//bram_we_b -> hardcoded to 0 (this block only reads from bram b)

    assign bram_wdata_b = 32'b0;
    assign bram_we_b = 4'b0;
  
//NC (not connected) wires 
    wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_out_NC;
    wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_out_NC;
    wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_NC;
    wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_NC;

    wire reset;
    assign reset = ~resetn;
    assign pe_reset = ~pe_resetn;

//matmul instance
    matmul_4x4_systolic u_matmul_4x4(
        .clk(clk),
        .reset(reset),
        .pe_reset(pe_reset),
        .start_mat_mul(start_mat_mul),
        .done_mat_mul(done_mat_mul),
        .address_mat_a(address_mat_a),
        .address_mat_b(address_mat_b),
        .address_mat_c(address_mat_c),
        .address_stride_a(address_stride_a),
        .address_stride_b(address_stride_b),
        .address_stride_c(address_stride_c),
        .a_data(bram_rdata_a),
        .b_data(bram_rdata_b),
        .a_data_in(a_data_in_NC),
        .b_data_in(b_data_in_NC),
        .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
        .c_data_out(bram_wdata_c),
        .a_data_out(a_data_out_NC),
        .b_data_out(b_data_out_NC),
        .a_addr(bram_addr_a),
        .b_addr(bram_addr_b),
        .c_addr(bram_addr_c),
        .c_data_available(c_data_available),
        .validity_mask_a_rows(validity_mask_a_rows),
        .validity_mask_a_cols_b_rows(validity_mask_a_cols_b_rows),
        .validity_mask_b_cols(validity_mask_b_cols),
        .final_mat_mul_size(8'd4),
        .a_loc(8'd0),
        .b_loc(8'd0)
    );

endmodule  

//////////////////////////////////
//Dual port RAM
//////////////////////////////////
//The following code will infer a dual-port BRAM
//This means the synthesis tool will recognize and use a BRAM for this code
module ram (
    addr0, 
    d0, 
    we0, 
    q0,  
    addr1,
    d1,
    we1,
    q1,
    clk);

    input [`AWIDTH-1:0] addr0;
    input [`MASK_WIDTH*`DWIDTH-1:0] d0;
    input [`MASK_WIDTH-1:0] we0;
    output reg [`MASK_WIDTH*`DWIDTH-1:0] q0;
    input [`AWIDTH-1:0] addr1;
    input [`MASK_WIDTH*`DWIDTH-1:0] d1;
    input [`MASK_WIDTH-1:0] we1;
    output reg [`MASK_WIDTH*`DWIDTH-1:0] q1;
    
    input clk;

    reg [31:0] ram[((1<<`AWIDTH)-1):0];

    always @(posedge clk)  
    begin 
        if (|we0 == 1'b1)
        begin
            ram[addr0] <= d0;
        end
        q0 <= ram[addr0];
    end
        
    always @(posedge clk)  
    begin
        if(|we1 == 1'b1)
        begin
            ram[addr1] <= d1;
        end
        
        q1 <= ram[addr1];
    end
    
endmodule