`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 11:33:54
// Design Name: 
// Module Name: baud_gen_tb
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
module baud_gen_tb();
reg i_clock =0;
reg i_rst;

wire baud_tick;
parameter clk_per_bit = 10;
baud_gen 
#(.clk_per_bit(clk_per_bit))
duv(.i_clock(i_clock),
    .i_rst(i_rst),
    .o_baud_tick(baud_tick));
always #5 i_clock <= ~i_clock;
initial begin   
    i_rst <= 1'b1;#100;
    i_rst <= 1'b0;#500;
    i_rst <= 1'b1;
end
endmodule