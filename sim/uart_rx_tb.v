`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 21:54:56
// Design Name: 
// Module Name: uart_rx_tb
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


module uart_rx_tb();
reg i_clock = 0;
reg i_rx_serialdata;
reg i_rx_rst;
reg i_parity_bit = 0;

parameter clk_per_bit = 10;
wire [7:0]o_rx_byte;
wire o_rx_done;
uart_rx
#(.clk_per_bit(clk_per_bit))
duv(.i_clock(i_clock),
    .i_rx_serialdata(i_rx_serialdata),
    .i_rx_rst(i_rx_rst),
    .i_parity_bit(i_parity_bit),
    .o_rx_byte(o_rx_byte[7:0]),
    .o_rx_done(o_rx_done));

always #5 i_clock <= ~i_clock;
initial begin
    //parity bit
    i_parity_bit <= 1'b0;
    i_rx_rst <= 1'b1;#100;
    i_rx_rst <= 1'b0;
    i_rx_serialdata <= 1'b1;#100;
    //startbit
    i_rx_serialdata <= 1'b0;#100;
    //databits
    i_rx_serialdata <= 1'b1;#100;
    i_rx_serialdata <= 1'b0;#100;
    i_rx_serialdata <= 1'b1;#100;
    i_rx_serialdata <= 1'b1;#100;
    i_rx_serialdata <= 1'b1;#100;
    i_rx_serialdata <= 1'b0;#100;
    i_rx_serialdata <= 1'b0;#100;
    i_rx_serialdata <= 1'b1;#100;
    
    //stopbit
    i_rx_serialdata <= 1'b0;#200;
    $finish;
end    
endmodule
