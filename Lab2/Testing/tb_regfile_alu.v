`timescale 1ps / 1ps

module tb_regfile_alu();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire [0:6] seg7_1, seg7_2;
	physical_tb uut3 (clk, rst, seg7_1, seg7_2);
	
	always #5 clk = ~clk;
	// give variations
	initial begin
		$monitor("Output: %d", seg7_1);
		//Initializ inputs
		clk = 0;
		rst = 0; #2;
		rst = 1; #5;
		rst = 0; #5;
	end
endmodule