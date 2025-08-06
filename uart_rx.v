`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2025 09:23:16 PM
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


module uart_rx #(parameter dbits=8 , sb_tick =16)(
    input rx,s_tick,
    input clk,reset,
    output reg rx_done_tick,
    output [dbits-1:0] rx_dout
    );
    
    localparam idle = 0 , start =1 , data=2 , stop=3;
    reg [1:0] state_next , state_reg;
    reg [3:0] s_next , s_reg;
    reg [2 :0] n_next, n_reg;
    reg [dbits-1:0] b_next , b_reg;
    
    always @(posedge clk , negedge reset) begin
        if(~reset) begin
            state_reg <= idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
        end
        else begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end
    end
    
    always @(*) begin
        state_next = state_reg;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        rx_done_tick = 1'b0;
        
        case(state_reg) 
            idle : if(~rx) begin
                      s_next =0;
                      state_next = start;
                   end
            start : if (s_tick) 
                        if (s_reg ==7 ) begin
                            s_next = 0;
                            n_next =0;
                            state_next = data;
                        end
                        else
                            s_next = s_reg +1;
           data : if(s_tick)
                       if (s_reg == 15) begin
                            s_next =0;
                            b_next = {rx , b_reg[dbits-1:1]};
                            if (n_reg == (dbits-1))
                                state_next = stop;
                            else
                                n_next = n_reg+1;
                       end
                       else
                            s_next = s_reg +1;
           stop: if(s_tick)
                       if (s_reg == (sb_tick -1 )) begin
                            rx_done_tick =1'b1;
                            state_next = idle;
                       end
                       else
                            s_next = s_reg +1;
           default: state_next = idle;    
        endcase
    end
    assign rx_dout = b_reg;
endmodule
