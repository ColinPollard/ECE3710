module mux2to1_4bit(A, B, ctrl, out);
	input [3:0] A, B;
	input ctrl;
	output reg[3:0] out;
	
	always @(A, B, ctrl)
		if(ctrl == 0)
			out = A;
		else
			out = B;
endmodule