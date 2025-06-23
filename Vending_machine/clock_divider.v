`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module clock_divider(clk ,rst, clk_div  );

input clk;
input rst;
output reg clk_div;

localparam constantNumber = 26'd50000000;

reg [25:0] count;

initial
begin
	count = 26'd0;
end
 
always @ (posedge(clk), posedge(rst))
begin
    if (rst == 1'b1)
        count <= 26'b0;
    else if (count == constantNumber - 1)
        count <= 26'b0;
    else
        count <= count + 26'd1;
end

always @ (posedge(clk), posedge(rst))
begin
    if (rst == 1'b1)
        clk_div <= 1'b0;
    else if (count == constantNumber - 1)
        clk_div <= ~clk_div;
    else
        clk_div <= clk_div;
end

endmodule
