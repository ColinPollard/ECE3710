`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire [15:0] out;
	CPU_datapath uut3 (clk, rst, out);
	
	always #5 clk = ~clk;
	// give variations
	initial begin
		$monitor("Output: %d", out);
		//Initializ inputs
		clk = 1;
		rst = 1; #2;
		rst = 0; #5;
		rst = 1; #5;
	end
endmodule