/*
 * ECE3710 Lab 2
 * This file contains a 2to1 and a 16to1 multiplexor.
 * 
 *
 */
 
module mux2to1(A, B, ctrl, out);
	input [15:0] A, B;
	input ctrl;
	output reg[15:0] out;
	
	always @(A, B, ctrl)
		if(ctrl == 0)
			out = A;
		else
			out = B;
endmodule

module mux4to1(A, B, C, D, ctrl, out);
	input [15:0] A, B, C, D;
	input [1:0] ctrl;
	output[15:0] out;
	wire [15:0] out1, out2;
	
	mux2to1 M1 (A, B, ctrl[0], out1);
	mux2to1 M2 (C, D, ctrl[0], out2);
	mux2to1 Mout(out1, out2, ctrl[1], out);
endmodule


module mux16to1(R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, ctrl, out);
	input [15:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15;
	input[3:0] ctrl;
	output[15:0] out;
	wire[15:0] a, b, c, d;
	
	mux4to1 M1 (R0, R1, R2, R3, ctrl[1:0], a);
	mux4to1 M2 (R4, R5, R6, R7, ctrl[1:0], b);
	mux4to1 M3 (R8, R9, R10, R11, ctrl[1:0], c);
	mux4to1 M4 (R12, R13, R14, R15, ctrl[1:0], d);
	mux4to1 Mout (a, b, c, d, ctrl[3:2], out);
endmodule
