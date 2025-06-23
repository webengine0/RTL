`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:56:44 02/09/2021 
// Design Name: 
// Module Name:    Vending_Machine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Vending_Machine(
input clk,
input quarter,
input nickel,
input dime,
input soda,
input diet,
output  Give_soda,
output  Give_diet
    );

reg [5:0] money=6'd0;
reg [1:0] sec=2'd0;
reg soda_out=1'd0;
wire clk_div,soda_deb,quarter_out,nickel_out,dime_out;

reg [26:0] clk_sec=27'd0;
reg diet_out=1'd0;
reg [2:0] Machine_states=3'd0;
wire [2:0] money_rec;
parameter Start=3'd0,
          Accepting_money=3'd1,
          Enough_money_recieved=3'd2,
          waiting_for_order=3'd3,
          order_released=3'd4;

clock_divider instance_clk (
    .clk(clk), 
    .rst(1'b0), 
    .clk_div(clk_div)
    );

debouncer instance_quarter (
    .clk(clk), 
    .clock_div(clk_div), 
    .in(quarter), 
    .out(quarter_out)
    );

debouncer instance_nickel (
    .clk(clk), 
    .clock_div(clk_div), 
    .in(nickel), 
    .out(nickel_out)
    );
	 
debouncer instance_dime (
    .clk(clk), 
    .clock_div(clk_div), 
    .in(dime), 
    .out(dime_out)
    );

debouncer instance_soda (
    .clk(clk), 
    .clock_div(clk_div), 
    .in(soda), 
    .out(soda_deb)
    );	 

assign money_rec={quarter_out,nickel_out,dime_out};

always @(posedge clk)
begin
clk_sec<=clk_sec+1'b1;
end

always@(posedge clk_div)
begin

case(Machine_states)

Start: begin        /// starting the FSM
		diet_out<=0;
		soda_out<=0;
		Machine_states<=Accepting_money;
end

Accepting_money: begin    //// recieving the money till money reaches atleast 45 

case(money_rec)
3'b001: money<=money + 6'd5;
3'b010: money<=money + 6'd10;
3'b011: money<=money + 6'd15;
3'b100: money<=money + 6'd25;
3'b101: money<=money + 6'd30;
3'b110: money<=money + 6'd35;
3'b111: money<=money + 6'd40;
endcase

if (money>=45)
Machine_states<=Enough_money_recieved;
else  Machine_states<=Accepting_money;

end

Enough_money_recieved: begin  //// wait for order whether soda or diet
		Machine_states<=waiting_for_order;
end

waiting_for_order: begin
	if(soda_deb||diet)
	begin
		Machine_states<=order_released;
		if(soda_deb)
		soda_out<=1;
		else if(diet)
		diet_out<=1;
	end
	else
		Machine_states<=waiting_for_order;
end

order_released: begin
if(clk_sec[26])
begin
sec<=sec+1'b1;
end

if(sec==2)
begin
	soda_out<=0;
	diet_out<=0;
	Machine_states<=Start;
	money<=0;
	sec<=0;
end

end
endcase
end

assign Give_soda=soda_out;
assign Give_diet=diet_out;

endmodule
