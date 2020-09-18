`timescale 1ps / 1ps

module tb_mux();

	// inputs - all registers
	reg[15:0] A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
	reg[3:0] select;

	// outputs - wires
	wire[15:0] out;

	mux16to1 uut1 (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, select, out);
	
	integer i;
	// give variations
	initial begin
		//initialize inputs
		A = 16'h0000; B = 16'h0001; C = 16'h0002; D = 16'h0003; E = 16'h0004; F = 16'h0005; G = 16'h0006; H = 16'h0007; 
		I = 16'h0008; J = 16'h0009; K = 16'h000a; L = 16'h000b; M = 16'h000c; N = 16'h000d; O = 16'h000e; P = 16'h000f;
		select = 0;
		
		for(i = 0; i < 2**4; i = i + 1) begin
			select = i;
			#5
			$display("Input %d, Output %d", i, out);
		end
	end
endmodule