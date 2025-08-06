`timescale 1ns / 1ps
module timer #(parameter bits=10)(
	input clk,reset,enable,
	input [bits-1:0] final_value,
	output done
);
	
	reg [bits-1:0]q_next , q_reg;
	
	always @(posedge clk,negedge reset) begin
		if(!reset)
			q_reg<='b0;
		else if(enable)
			q_reg<= q_next;
		else 
			q_reg <=q_reg;
	end
	
	assign done = q_reg == final_value;
	always @(done,q_reg) begin
		q_next = done? 'b0 : q_reg +1;
	end
	
endmodule 