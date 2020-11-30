`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire serial, active, done, write_enable;
	wire [15:0] out;
	
	CPU_test_datapath uut3 (clk, rst, out, write_enable, serial, active, done);
	
	always #5 clk = ~clk;
//	always@(posedge clk) begin 
//		if(enable)
//			$display("Output: %d", out);
//	end
	initial begin
		//Initialize inputs
		clk = 1;
		rst = 0; #2;
		rst = 1; #10;
		rst = 0; #5;		
	end
endmodule