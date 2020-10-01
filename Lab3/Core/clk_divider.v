/*
 * Luke Majors
 * April 02, 2020
 * 
 * ECE 3700 -- Lab 4
 * This module represents a clock divider to convert a
 * 50 MHz clock to a 1Hz clock
 */
 
 module clk_divider(clk_in, rst, clk_out);
 
	input clk_in, rst;
	output reg clk_out;
 
	reg [24:0] count;
 
	always @(posedge clk_in, posedge rst)
	begin
		
		if(rst == 1) begin
			count <= 25'd0;
			clk_out <= 0;
		end
		else if(count == 25000000) begin
			count <= 25'd0;
			clk_out <= ~clk_out;
		end
		else begin
			count <= count;
			clk_out <= clk_out;
			count <= count + 1'b1;
		end
	end
 
 endmodule
 