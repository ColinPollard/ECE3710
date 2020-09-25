`timescale 1ps / 1ps

module tb_regfile_alu();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire [6:0] seg7;
	physicalTB uut3 (clk, seg7, rst);
	
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