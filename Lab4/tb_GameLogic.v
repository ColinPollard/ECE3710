`timescale 1ps / 1ps

module tb_GameLogic();

	//input - start
	reg start

	
	CPU_datapath uut4(clk, rst, write_enable, serial, done);
	
	always #5 clk = ~clk;
	
	initial begin
		//Initialize inputs
		clk = 1;
		rst = 1; #2;
		rst = 0; #10;
		rst = 1; #5;		
	end
endmodule