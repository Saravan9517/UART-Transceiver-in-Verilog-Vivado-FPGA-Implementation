`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2026 23:31:20
// Design Name: 
// Module Name: top_tb_1
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
`timescale 1ns/1ps

module top_tb();

reg i_clock = 0;
reg i_tx_enable;
reg [7:0] i_tx_byte;
reg rst = 0;

wire parity_error;
wire frame_error;
wire [7:0] o_rx_byte;
wire o_rx_done;
wire o_rx_busy;

parameter clk_per_bit = 10;

top
#(.clk_per_bit(clk_per_bit))
duv(
    .i_clock(i_clock),
    .i_tx_enable(i_tx_enable),
    .i_tx_byte(i_tx_byte),
    .rst(rst),

    .parity_error(parity_error),
    .frame_error(frame_error),
    .o_rx_byte(o_rx_byte),
    .o_rx_done(o_rx_done),
    .o_rx_busy(o_rx_busy)
);

always #5 i_clock = ~i_clock;


//--------------------------------------------------
// Task to transmit one byte
//--------------------------------------------------
task send_byte;
input [7:0] data;

begin
    @(posedge i_clock);
    i_tx_byte   <= data;
    i_tx_enable <= 1'b1;

    @(posedge i_clock);
    i_tx_enable <= 1'b0;

    // Wait until receiver completes
    wait(o_rx_done);

end

endtask


//--------------------------------------------------
// Test Sequence
//--------------------------------------------------
initial
begin

    rst = 1;
    i_tx_enable = 0;
    i_tx_byte = 8'h00;

    #40;
    rst = 0;

    //------------------------------------------------
    // Normal Data Tests
    //------------------------------------------------

    send_byte(8'h00);

    send_byte(8'hFF);

    send_byte(8'h55);

    send_byte(8'hAA);

    send_byte(8'hBA);

    send_byte(8'h96);

    send_byte(8'h3C);

    send_byte(8'h81);

    #500;

    $display("--------------------------------");
    $display("Simulation Finished Successfully");
    $display("--------------------------------");

    $finish;

end

endmodule