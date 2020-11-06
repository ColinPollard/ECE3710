`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire [15:0] out;
	wire enable;
	CPU_test_datapath uut3 (clk, rst, out, enable);
	
	always begin 
		#5 clk = ~clk;
	end
	initial begin
		//Initialize inputs
		clk = 1;
		rst = 0; #2;
		rst = 1; #10;
		rst = 0; #5;		
	end
endmodule