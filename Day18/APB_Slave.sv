`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2024 12:49:11 PM
// Design Name: 
// Module Name: APB_Slave
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


module APB_Slave(
 input         wire        clk,
 input         wire        reset,

 input         wire        psel_i,
 input         wire        penable_i,
 input         wire[9:0]   paddr_i,
 input         wire        pwrite_i,
 input         wire[31:0]  pwdata_i,
 output        wire[31:0]  prdata_o,
 output        wire        pready_o
    );
    
    //valid apb_req
    logic apb_req;
    
    
    assign apb_req = psel_i && penable_i;
    
    //initiate the memory interface
    
    mem_interface DAY17 (
        .clk            (clk),
        .reset          (reset),
        .req_i          (apb_req),
        .req_rnw_i      (~pwrite_i),
        .req_addr_i     (paddr_i),
        .req_wdata_i    (pwdata_i),
        .req_ready_o    (pready_o),
        .req_rdata_o    (prdata_o)
      );
    
endmodule
