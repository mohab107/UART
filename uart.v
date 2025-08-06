`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2025 07:53:26 PM
// Design Name: 
// Module Name: uart
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


module uart #(parameter dbits= 8 ,sb_tick =16)(
    input [10:0] TIMER_FINAL_VALUE,
    input clk,reset,
    
    input rx, rd_uart,
    output rx_empty , 
    output [dbits -1:0 ] r_data,
    
    input wr_uart,
    input [dbits-1:0] w_data,
    output tx_full, tx
    );
    
    wire tick;
    
    timer #(.bits(11)) baud_rate_gen (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .final_value(TIMER_FINAL_VALUE),
        .done(tick)
    );
    
    wire rx_done_tick;
    wire [dbits-1:0] rx_dout;
    
    uart_rx #(.dbits(dbits) , .sb_tick(sb_tick)) receiver (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .s_tick(tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );
    
    fifo_generator_0 rx_fifo (
      .clk(clk),      // input wire clk
      .rst(~reset),      // input wire rst
      .din(rx_dout),      // input wire [7 : 0] din
      .wr_en(rx_done_tick),  // input wire wr_en
      .rd_en(rd_uart),  // input wire rd_en
      .dout(r_data),    // output wire [7 : 0] dout
      .full(),    // output wire full
      .empty(rx_empty)  // output wire empty
    );
    
    wire [dbits-1:0] tx_din;
    wire tx_done_tick;
    wire tx_fifo_empty;
    
    fifo_generator_1 tx_fifo (
      .clk(clk),      // input wire clk
      .rst(~reset),      // input wire rst
      .din(w_data),      // input wire [7 : 0] din
      .wr_en(wr_uart),  // input wire wr_en
      .rd_en(tx_done_tick),  // input wire rd_en
      .dout(tx_din),    // output wire [7 : 0] dout
      .full(tx_full),    // output wire full
      .empty(tx_fifo_empty)  // output wire empty
    );
   
    uart_tx #(.dbits(dbits) , .sb_tick(sb_tick)) transmitter (
      .clk(clk),
      .reset(reset),
      .tx_din(tx_din),
      .tx_start(~tx_fifo_empty),
      .s_tick(tick),
      .tx(tx),
      .tx_done_tick(tx_done_tick)
   );
endmodule
