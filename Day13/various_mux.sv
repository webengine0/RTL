`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 05:54:03 AM
// Design Name: 
// Module Name: various_mux
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


module various_mux(
    input wire [3:0]a_i,
    input wire [3:0]sel_i,
    
    output wire y_ter_o,
    
    output logic y_case_o,
    
    output logic y_ifelse_o,
    
    output logic y_loop_o,
    
    output wire y_aor_o
    
    );
    
    assign y_ter_o = sel_i[0] ? a_i[0] :
                     sel_i[1] ? a_i[1] :
                     sel_i[2] ? a_i[2] :
                     a_i[3];
    
    always_comb begin
    case(sel_i)
    4'b0001: y_case_o = a_i[0];
    4'b0010: y_case_o = a_i[1];
    4'b0100: y_case_o = a_i[2];
    4'b1000: y_case_o = a_i[3];
    default: y_case_o = 1'bx;
    endcase
    end
    
    always_comb begin
        if(sel_i[0]) y_ifelse_o = a_i[0];
        else if(sel_i[1]) y_ifelse_o = a_i[1];
        else if(sel_i[2]) y_ifelse_o = a_i[2];
        else if(sel_i[3]) y_ifelse_o = a_i[3];
        else  y_ifelse_o = 1'bx;  
    end
    
    always_comb begin
    y_loop_o = 0;
        for(int i=0; i<4; i++)begin
            y_loop_o = (sel_i[0] & a_i[0]) | y_loop_o;
        
        end
    end
    
      assign y_aor_o = (sel_i[0] & a_i[0]) |
                     (sel_i[1] & a_i[1]) |
                     (sel_i[2] & a_i[2]) |
                     (sel_i[3] & a_i[3]);

    
endmodule
