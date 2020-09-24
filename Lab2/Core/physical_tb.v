//Physical test bench for the Regfile ALU datapath

module physical_tb (clk, rst, seg7_1, seg7_2);
	input clk, rst;
	output[0:6] seg7_1, seg7_2;
	
	//Intermediate values
	wire[3:0] write_select, regA, regB;
	wire[4:0] flags;
	wire[7:0] op;
	wire reg_imm, write_enable, reg_reset;
	reg[15:0] imm;
	wire [15:0] reg_b_val, A, B, out;
	
	fibonacci_fsm fsm(clk, rst, write_enable, write_select, regA, regB, op, reg_imm, reg_reset);
	regfile r(A, reg_b_val, regA, regB, out, write_select, write_enable, clk, rst);
	mux2to1 m(reg_b_val, imm, reg_imm, B);
	alu a(A, B, out, op, flags);
	bcd_to_sev_seg disp1(B[3:0], seg7_1);
	bcd_to_sev_seg disp2(B[7:4], seg7_2);
	
	always@(write_select)
		imm = write_select;
	
endmodule
