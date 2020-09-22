`timescale 1ps / 1ps

module tb_fsm();

	// inputs - all registers
	reg rst, clk;

	// outputs - wires
	wire WE, Rres, rI;
	wire[3:0] regA, regB, WS;
	wire[7:0] op;
	fibonacci_fsm uut2 (clk, rst, WE, WS, regA, regB, op, rI, Rres);
	
	integer i;
	always #5 clk = ~clk;
	// give variations
	initial begin
		//Initializ inputs
		clk = 0;
		rst = 0; #2;
		rst = 1; #5;
		rst = 0; #5;
		
		for(i = 0; i < 2**5; i = i + 1) begin
			#5
			$display("State: %d, WE: %d WS: %d", i, WE, WS);
		end
	end
endmodule