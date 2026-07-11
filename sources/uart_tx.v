`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2026 21:10:12
// Design Name: 
// Module Name: uart_tx
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
module uart_tx
#(parameter clk_per_bit = 10)
(input i_clock,
input i_tx_enable,
input [7:0]i_tx_byte,
input i_tx_rst,

output reg o_tx_serialdata,
output reg o_tx_done);
//parity bit
wire parity_bit;
assign parity_bit = ^i_tx_byte;
reg i_baud_enable;
baud_gen #(clk_per_bit)
baudrate(.i_clock(i_clock),
         .i_rst(i_tx_rst),
         .i_enable(i_baud_enable),
         .o_baud_tick(baud_tick));
         
localparam s_IDLE = 3'b000;
localparam s_START_BIT = 3'b001;
localparam s_DATA_BIT = 3'b010;
localparam s_PARITY_BIT = 3'b011;
localparam s_STOP_BIT = 3'b100;

reg [2:0] s_tx_main = 3'b000;
reg [2:0]s_tx_index = 3'b000;
always@(posedge i_clock) begin
    if(i_tx_rst) begin
        s_tx_main <= s_IDLE;
        s_tx_index<= 0;
        o_tx_serialdata <= 1'b1;
        o_tx_done <= 1'b0;
        i_baud_enable <= 1'b0;
        end
        else begin
            case(s_tx_main)
                s_IDLE:   //in idle state o_tx_serialdata = 1 it has to be high so the receiver detects the start bit when its low in start_bit state
                    begin
                        i_baud_enable = 1'b0;
                        o_tx_done <=0;
                        o_tx_serialdata <= 1'b1;
                        if(i_tx_enable)begin
                            s_tx_index <= 0;
                            s_tx_main <= s_START_BIT;
                         end
                         else begin
                            s_tx_main <= s_IDLE;
                         end
                     end
            
                s_START_BIT:// the o_tx_serialdata = 1'b0 and it stays for one bit_period dependent on baudrate
                    begin
                        i_baud_enable <= 1'b1;
                        if(~baud_tick) begin
                            o_tx_serialdata <= 1'b0;
                        end
                        else begin
                            s_tx_main <= s_DATA_BIT;
                        end
                    end
                    
                s_DATA_BIT: //after start_bit on o_tx_serial_data the databits are transmitted from lsb to msb through o_tx_serialdata
                    begin
                        o_tx_serialdata <= i_tx_byte[s_tx_index];
                        if(baud_tick) begin
                             if(s_tx_index < 7) begin
                                s_tx_index <= s_tx_index+1;
                             end    
                             else begin
                                s_tx_main <= s_PARITY_BIT;
                             end
                        end   
                     end
                s_PARITY_BIT:
                    begin
                         o_tx_serialdata <= parity_bit;
                         if(baud_tick) begin
                             s_tx_main <= s_STOP_BIT;
                         end
                    end
                            
                s_STOP_BIT:// after transmitting the databits the stopbit is transmitted as high signal which then after a bit period enables the 'done' signal
                    begin
                        if(~baud_tick) begin
                            o_tx_serialdata <= 1'b1;
                        end
                        else begin
                            i_baud_enable <= 1'b0;
                            o_tx_done <= 1'b1;
                            s_tx_main <= s_IDLE;
                        end
                    end  
                default :s_tx_main <= s_IDLE;
             endcase
        end     
   end     
endmodule
