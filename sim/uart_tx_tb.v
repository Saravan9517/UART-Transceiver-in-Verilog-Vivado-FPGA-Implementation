`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2026 09:32:01
// Design Name: 
// Module Name: uart_tx_tb
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
module uart_tx_tb();
reg i_clock = 0;
reg i_tx_enable;
reg [7:0]i_tx_byte;
reg rst = 0;

parameter clk_per_bit = 10417;//baudrate=9600,so clk_per_bit = freq of clk/baudrate = 10^8/9600;

wire o_tx_serialdata;
wire o_tx_done;

always #5 i_clock <= ~i_clock;
uart_tx #(.clk_per_bit(clk_per_bit)) 
duv(.i_clock(i_clock),.i_tx_enable(i_tx_enable),.i_tx_byte(i_tx_byte[7:0]),.i_tx_rst(rst),.o_tx_serialdata(o_tx_serialdata),.o_tx_done(o_tx_done));
initial begin
    i_tx_byte = 8'b1011_1010;
    i_tx_enable <= 0;#50;
    i_tx_enable <= 1'b1;#100;
    #1500000;
    i_tx_enable <= 1'b0;
    i_tx_byte = 8'b1001_0110;
    i_tx_enable <= 0;#50;
    i_tx_enable <= 1'b1;
    #100000;
end
endmodule