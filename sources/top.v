`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 14:11:55
// Design Name: 
// Module Name: top
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
module top
#(parameter clk_per_bit = 10)
(input i_clock,
input i_tx_enable,
input [7:0]i_tx_byte,
input rst,

output parity_error,
output frame_error,
output [7:0]o_rx_byte,
output o_rx_done,
output o_rx_busy);

wire o_parity_bit;
wire o_tx_serialdata;
wire o_tx_done;
//instantiate tx and rx modules
uart_tx 
#(.clk_per_bit(clk_per_bit))
tx( .i_clock(i_clock),
    .i_tx_enable(i_tx_enable),
    .i_tx_byte(i_tx_byte[7:0]),
    .i_tx_rst(rst),
    
    .o_tx_serialdata(o_tx_serialdata),
    .o_tx_done(o_tx_done));
    
uart_rx
#(.clk_per_bit(clk_per_bit))
rx( .i_clock(i_clock),
    .i_rx_serialdata(o_tx_serialdata),
    .i_rx_rst(rst),
    
    .parity_error(parity_error),
    .frame_error(frame_error),
    .o_rx_byte(o_rx_byte[7:0]),
    .o_rx_done(o_rx_done),
    .o_rx_busy(o_rx_busy));
endmodule