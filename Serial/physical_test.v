module physical_test(clk, serial);
	input clk;
	output reg serial;
	
	always@(posedge clk)
		serial = 1'b0;
	
	
	
endmodule