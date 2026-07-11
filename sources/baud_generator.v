`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 11:02:26
// Design Name: 
// Module Name: baud_generator
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
module baud_gen
#(parameter clk_per_bit = 10)
(input i_clock,
input i_rst,
output reg  o_baud_tick);
reg [15:0]clk_cycle_count =0;
always@(posedge i_clock) begin
    if(i_rst)begin
        clk_cycle_count <= 0;
        o_baud_tick <= 0;
    end
    else begin
        if(clk_cycle_count < clk_per_bit-1) begin
            clk_cycle_count <= clk_cycle_count+1;
            o_baud_tick <= 0;
        end
        else begin 
            clk_cycle_count <= 0;
            o_baud_tick <= 1'b1;
        end
    end
end
endmodule