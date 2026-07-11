`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 16:26:11
// Design Name: 
// Module Name: uart_rx
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
module uart_rx
#(parameter clk_per_bit = 10)
(input i_clock,
input i_rx_serialdata,
input i_rx_rst,
input i_parity_bit,

output reg parity_error,
output reg frame_error,
output reg [7:0]o_rx_byte,
output reg o_rx_done);

baud_gen #(clk_per_bit) 
 baudrate(.i_clock(i_clock),
          .i_rst(i_rx_rst),
          .o_baud_tick(baud_tick));
localparam s_IDLE = 3'b000;
localparam s_START_BIT = 3'b001;
localparam s_DATA_BIT = 3'b010;
localparam s_PARITY_BIT = 3'b011;
localparam s_STOP_BIT = 3'b100;

reg r_parity_bit = 0;
reg [2:0] s_rx_main = s_IDLE;
reg [2:0] s_rx_index = 0;
reg [15:0] clk_cycle_count = 0;
always@(posedge i_clock) begin
    if(i_rx_rst) begin
        s_rx_main <= s_IDLE;
        s_rx_index <= 0;
        clk_cycle_count <= 0;
        frame_error <=0;
       
    end
    else begin
        case(s_rx_main)
            s_IDLE:
                begin
                    o_rx_byte <= 0;
                    o_rx_done <= 0;
                    s_rx_main <= 0;
                    frame_error <=0;
                    parity_error <= 0;
                    if(i_rx_serialdata == 1'b1)
                        begin
                            clk_cycle_count <= 0;
                            s_rx_index <=0;
                            s_rx_main <= s_IDLE;
                            o_rx_done <= 0;
                        end
                    else
                        begin
                             s_rx_main <= s_START_BIT;  
                        end
                end
                
             s_START_BIT:
                    begin
                        if(i_rx_serialdata == 1'b0) begin
                            if(clk_cycle_count < (clk_per_bit/2))
                                begin
                                    clk_cycle_count <= clk_cycle_count+1;
                                end
                            else
                                begin
                                clk_cycle_count <= 0;
                                s_rx_main <= s_DATA_BIT;
                                end
                        end
                        else
                            begin
                                s_rx_main <= s_IDLE;
                            end  
                    end
                    
             s_DATA_BIT:
                    begin
                            if(clk_cycle_count < clk_per_bit-1)
                                begin
                                    clk_cycle_count <= clk_cycle_count+1;
                                end
                            else
                                begin
                                    clk_cycle_count <= 0;
                                    o_rx_byte[s_rx_index] <= i_rx_serialdata;
                                    if(s_rx_index < 7) 
                                            s_rx_index <= s_rx_index+1;
                                    else
                                            s_rx_main <= s_PARITY_BIT;
                                end
                    end 
             
             s_PARITY_BIT:
                    begin
                        r_parity_bit <= o_rx_byte[7]^o_rx_byte[6]^o_rx_byte[5]^o_rx_byte[4]^o_rx_byte[3]^o_rx_byte[2]^o_rx_byte[1]^o_rx_byte[0];
                         if(clk_cycle_count < clk_per_bit-1)
                                begin
                                    clk_cycle_count <= clk_cycle_count+1;
                                end
                            else
                                begin
                                    clk_cycle_count <= 0;
                                    if(r_parity_bit == i_parity_bit) begin
                                        parity_error <= 0;
                                    end
                                    else begin
                                        parity_error <= 1'b1;
                                    end
                                    s_rx_main <= s_STOP_BIT;
                            end
                    end
                                          
             s_STOP_BIT:
                    begin
                        if(clk_cycle_count < clk_per_bit-1)
                            begin
                                clk_cycle_count <= clk_cycle_count+1;
                            end
                        else
                            begin 
                                if(i_rx_serialdata == 1'b1) begin
                                    o_rx_done <= 1'b1;
                                    frame_error <=1'b0;
                                end
                                else begin
                                    frame_error <= 1'b1;
                                end
                                s_rx_main <= s_IDLE;
                            end
                    end
                
              default: s_rx_main <= s_IDLE;      
        endcase
    end
end
endmodule