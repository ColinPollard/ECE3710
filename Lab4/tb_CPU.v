`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk;//clk2;

	// outputs - wires
	wire serial, done, write_enable;
	
	CPU_datapath uut3 (clk, rst, write_enable, serial, done);
	
	//always #5 clk2 = ~clk2;
	always #5 clk = ~clk;
//	always@(posedge clk) begin 
//		if(enable)
//			$display("Output: %d", out);
//	end
	initial begin
		//Initialize inputs
		clk = 1;
		rst = 1; #2;
		rst = 0; #10;
		rst = 1; #5;		
	end
endmodule