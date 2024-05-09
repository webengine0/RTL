`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 06:30:14 AM
// Design Name: 
// Module Name: priority_arbiter
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


module priority_arbiter #(
    parameter NUM_PORTS = 4
)(
    input wire [NUM_PORTS-1:0]req_i,
    output wire [NUM_PORTS-1:0]gnt_o
    );
    
    assign gnt_o[0] = req_i[0];
    
    genvar i;
    for (i=1; i<NUM_PORTS; i=i+1) begin
        assign gnt_o[i] = req_i[i] & (|gnt_o[i-1:0]);
    end
    
    
endmodule
