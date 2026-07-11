`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 14:32:30
// Design Name: 
// Module Name: top_tb
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
module top_tb();
reg i_clock = 0;
reg i_tx_enable;
reg [7:0]i_tx_byte;
reg rst = 0;

wire parity_error;
wire frame_error;
wire [7:0]o_rx_byte;
wire o_rx_done;
parameter clk_per_bit = 10;
always #5 i_clock <= ~i_clock;
top
#(.clk_per_bit(clk_per_bit))
duv(.i_clock(i_clock),
    .i_tx_enable(i_tx_enable),
    .i_tx_byte(i_tx_byte[7:0]),
    .rst(rst),
    
    .parity_error(parity_error),
    .frame_error(frame_error),
    .o_rx_byte(o_rx_byte[7:0]),
    .o_rx_done(o_rx_done));

initial begin
    i_tx_byte <= 8'b1011_1010;
    i_tx_enable <= 0;#50;
    i_tx_enable <= 1'b1;#500;
    rst <= 1;#100;
    rst <= 0;#1000;
    
    
    i_tx_byte <= 8'b1001_0110;
    i_tx_enable <= 0;#50;
    i_tx_enable <= 1'b1;
    #1000000;
end
endmodule