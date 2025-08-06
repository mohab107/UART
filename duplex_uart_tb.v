`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2025 04:55:28 PM
// Design Name: 
// Module Name: duplex_uart_tb
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2025 04:41:02 PM
// Design Name: 
// Module Name: duplex_uart
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


module duplex_uart_tb (
    );
    
    parameter dbits =8 , sb_tick =16;
    reg clk,reset;
    reg [10:0] TIMER_FINAL_VALUE;
    
    reg rx_a , rx_b ;
    reg rd_uart_a , rd_uart_b;
    wire [dbits-1:0] r_data_a , r_data_b;
    wire rx_empty_a , rx_empty_b;
    
    reg [dbits-1:0] w_data_a , w_data_b;
    reg wr_uart_a, wr_uart_b;
    wire tx_a,tx_b;
    wire tx_full_a , tx_full_b;
    
    
    always @(*) begin
        rx_a = tx_b;
        rx_b = tx_a;
    end
    
    uart #(.dbits(dbits) , .sb_tick(sb_tick)) uart_a (
        .clk(clk),
        .reset(reset),
        .TIMER_FINAL_VALUE(TIMER_FINAL_VALUE),
        .rx(rx_a), 
        .rd_uart(rd_uart_a),
        .rx_empty(rx_empty_a) , 
        .r_data(r_data_a),
        .wr_uart(wr_uart_a),
        .w_data(w_data_a),
        .tx_full(tx_full_a), 
        .tx(tx_a)
    );
    
    uart #(.dbits(dbits) , .sb_tick(sb_tick)) uart_b (
        .clk(clk),
        .reset(reset),
        .TIMER_FINAL_VALUE(TIMER_FINAL_VALUE),
        .rx(rx_b), 
        .rd_uart(rd_uart_b),
        .rx_empty(rx_empty_b) , 
        .r_data(r_data_b),
        .wr_uart(wr_uart_b),
        .w_data(w_data_b),
        .tx_full(tx_full_b), 
        .tx(tx_b)
    );
    
    localparam t=10;
    always begin
        clk=1'b0;
        #(t/2);
        clk =1'b1;
        #(t/2);
    end
    
    initial begin
        reset =1'b0;
        
        TIMER_FINAL_VALUE =650;
        #1 reset= 1'b1;
        
        //initialize transmitter
        repeat(4) @(negedge clk);
        w_data_a = 8'h3F;
        w_data_b = 8'hAB;
        
        repeat (4) @(negedge clk);
        wr_uart_a =1'b1;
        wr_uart_b =1'b1;
                
        @(negedge clk);
        wr_uart_a =1'b0;
        wr_uart_b =1'b0;
        
        //start bit 
        repeat(16 * TIMER_FINAL_VALUE) @(negedge clk);
        
        // data to be sent
        repeat (8 * 16 * TIMER_FINAL_VALUE) @(negedge clk);
        
        // stop bit
        repeat (16 * TIMER_FINAL_VALUE) @(negedge clk);
        
        repeat (1000) @(negedge clk) ;
        rd_uart_a= 1'b1;
        rd_uart_b=1'b1;
        @(negedge clk);
        rd_uart_a= 1'b0;
        rd_uart_b=1'b0;
        
        repeat(1000) @(negedge clk);
        $stop;
    end
endmodule
