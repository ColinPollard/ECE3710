`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire [15:0] out;
	CPU_test_datapath uut3 (clk, rst, out);
	
	always #5 clk = ~clk;
	// give variations
	integer i;
	initial begin
		$monitor("Output: %d", out);
		//Initialize inputs
		clk = 1;
		rst = 0; #2;
		rst = 1; #10;
		rst = 0; #5;
		for(i = 0; i < 1000; i = i + 1)
		begin
			#5;
		end
	end
endmodule