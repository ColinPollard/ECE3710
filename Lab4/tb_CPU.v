`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk;//clk2;

	// outputs - wires
	wire serial, done, en1, en2, en3, en4e;
	
	CPU_test_datapath uut3 (clk, rst, en1, en2, en3, en4, serial);
	
	//always #5 clk2 = ~clk2;
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