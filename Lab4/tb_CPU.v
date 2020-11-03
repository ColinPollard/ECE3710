`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire [6:0] seg7;
	CPU_datapath uut3 (clk, rst, seg7);
	
	always #5 clk = ~clk;
	// give variations
	initial begin
		//$monitor("Output: %d", seg7_1);
		//Initializ inputs
		clk = 1;
		rst = 1; #2;
		rst = 0; #5;
		rst = 1; #5;
	end
endmodule