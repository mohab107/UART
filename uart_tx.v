`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2025 10:08:58 PM
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


module uart_tx #(parameter dbits = 8 , sb_tick=16)(
        input clk , reset,
        input [dbits-1:0] tx_din,
        input tx_start , s_tick,
        output tx,
        output reg tx_done_tick
    );
    localparam idle=0 , start =1 , data=2, stop=3;
    reg [1:0] state_next , state_reg;
    reg[3:0] s_next , s_reg;
    reg[dbits-1:0] b_next , b_reg;
    reg [2 : 0] n_next , n_reg;
    reg tx_next , tx_reg;
    
    always @(posedge clk ,negedge reset) begin
        if(~reset) begin
            state_reg <= idle ;
            s_reg <= 0;
            b_reg <=0 ;
            n_reg <=0;
            tx_reg <=1'b1;
        end
        else begin
            state_reg <= state_next ;
            s_reg <= s_next;
            b_reg <= b_next ;
            n_reg <= n_next; 
            tx_reg <= tx_next;           
        end
    end
    
    always @(*) begin
        state_next = state_reg;
        s_next = s_reg;
        b_next = b_reg;
        n_next = n_reg;
        tx_done_tick =1'b0;
        tx_next = tx_reg;
        
        case(state_reg)
            idle : begin
                        tx_next =1'b1;
                        if(tx_start) begin
                            s_next = 0;
                            b_next = tx_din;
                            state_next = start;
                        end 
                    end    
            start: begin
                        tx_next = 1'b0;
                        if (s_tick)
                            if (s_reg == 15) begin
                                s_next = 0;
                                n_next =0;
                                state_next = data;
                            end 
                            else 
                                s_next = s_reg +1;
                    end     
            data: begin
                        tx_next= b_reg[0];
                        if (s_tick)
                            if(s_reg ==15) begin
                                s_next =0;
                                b_next = {1'b0 , b_reg[dbits-1 : 1]};
                                if (n_reg == (dbits-1))
                                    state_next = stop;
                                else
                                    n_next = n_reg +1;
                            end
                            else
                                s_next = s_reg +1;
                   end
            stop: begin
                        tx_next =1'b1;
                        if (s_tick)
                            if(s_reg == (sb_tick -1)) begin
                                tx_done_tick =1'b1;
                                state_next = idle;
                            end
                            else
                                s_next = s_reg +1;
                  end
            default: state_next = idle;    
        endcase
    end
    
    assign tx = tx_reg;
endmodule
