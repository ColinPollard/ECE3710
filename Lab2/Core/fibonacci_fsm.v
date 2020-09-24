/*
 * Author: Colin Pollard, Ian Lavin, Luke Majors, Mckay Mower
 * Date: 9/17/2020
 *
 * This module represents a finite state machine that is used to test the ALU
 * and the register file. This fsm specifically computes a fibonacci sequence
 * using the ALU and regfile.
 */
 
module fibonacci_fsm(clk, rst, write_enable, write_select, regA, regB, op, reg_imm, reg_reset, imm_val);
	input clk, rst;
	output reg[3:0] write_select, regA, regB;
	output reg[7:0] op;
	output reg reg_imm, write_enable, reg_reset;
	output reg [15:0] imm_val;
	
	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[4:0] S0 = 5'h00, S1 = 5'h01, S2 = 5'h02, S3 = 5'h03, S4 = 5'h04, S5 = 5'h05, S6 = 5'h06, S7 = 5'h07,
						S8 = 5'h08, S9 = 5'h09, S10 = 5'h0a, S11 = 5'h0b, S12 = 5'h0c, S13 = 5'h0d, S14 = 5'h0e, S15 = 5'h0f,
						S16 = 5'h10;
	
	//Include opcode parameters 
	`include "../../opcodes.v"
	
	//Update state
	always @(posedge clk)
	begin
		if(rst) y <= S0;
		else if(y == S16)
			y <= y;
		else begin
			y <= y + 1;
		end
	end
		
	//Update output
	always @(y)
	begin
		case(y)
			S0: begin //Set (reset) all registers to 0
				op = NOP;
				reg_reset = 1;
				write_select = 4'bx;
				write_enable = 1'bx;
				regA = 4'bx;
				regB = 4'bx;
				reg_imm = 1'bx;
				imm_val = 16'bx;
			end
			S1: begin //Set reg0 to 1
				op = ADDI;
				reg_reset = 0;
				write_select = 4'h0;
				write_enable = 1'b1;
				regA = 4'h0;
				regB = 4'bx;
				reg_imm = 1'b1;
				imm_val = 16'h0001;
			end
			S2: begin //Set reg1 to 2
				op = ADDI;
				reg_reset = 0;
				write_select = 4'h1;
				write_enable = 1'b1;
				regA = 4'h1;
				regB = 4'bx;
				reg_imm = 1'b1;
				imm_val = 16'h0002;
			end
			S3: begin //reg2 = reg0 + reg1
				op = ADD;
				reg_reset = 0;
				write_select = 4'h2;
				write_enable = 1'b1;
				regA = 4'h0;
				regB = 4'h1;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S4: begin //reg3 = reg1 + reg2
				op = ADD;
				reg_reset = 0;
				write_select = 4'h3;
				write_enable = 1'b1;
				regA = 4'h1;
				regB = 4'h2;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S5: begin //reg4 = reg2 + reg3
				op = ADD;
				reg_reset = 0;
				write_select = 4'h4;
				write_enable = 1'b1;
				regA = 4'h2;
				regB = 4'h3;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S6: begin //reg5 = reg3 + reg4
				op = ADD;
				reg_reset = 0;
				write_select = 4'h5;
				write_enable = 1'b1;
				regA = 4'h3;
				regB = 4'h4;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S7: begin //reg6 = reg4 + reg5
				op = ADD;
				reg_reset = 0;
				write_select = 4'h6;
				write_enable = 1'b1;
				regA = 4'h4;
				regB = 4'h5;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S8: begin //reg7 = reg5 + reg6
				op = ADD;
				reg_reset = 0;
				write_select = 4'h7;
				write_enable = 1'b1;
				regA = 4'h5;
				regB = 4'h6;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S9: begin //reg8 = reg6 + reg7
				op = ADD;
				reg_reset = 0;
				write_select = 4'h8;
				write_enable = 1'b1;
				regA = 4'h6;
				regB = 4'h7;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S10: begin //reg9 = reg7 + reg8
				op = ADD;
				reg_reset = 0;
				write_select = 4'h9;
				write_enable = 1'b1;
				regA = 4'h7;
				regB = 4'h8;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S11: begin //reg10 = reg8 + reg9
				op = ADD;
				reg_reset = 0;
				write_select = 4'ha;
				write_enable = 1'b1;
				regA = 4'h8;
				regB = 4'h9;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S12: begin //reg11 = reg9 + reg10
				op = ADD;
				reg_reset = 0;
				write_select = 4'hb;
				write_enable = 1'b1;
				regA = 4'h9;
				regB = 4'ha;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S13: begin //reg12 = reg10 + reg11
				op = ADD;
				reg_reset = 0;
				write_select = 4'hc;
				write_enable = 1'b1;
				regA = 4'ha;
				regB = 4'hb;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S14: begin //reg13 = reg11 + reg12
				op = ADD;
				reg_reset = 0;
				write_select = 4'hd;
				write_enable = 1'b1;
				regA = 4'hb;
				regB = 4'hc;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S15: begin //reg14 = reg12 + reg13
				op = ADD;
				reg_reset = 0;
				write_select = 4'he;
				write_enable = 1'b1;
				regA = 4'hc;
				regB = 4'hd;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			S16: begin //reg15 = reg13 + reg14
				op = ADD;
				reg_reset = 0;
				write_select = 4'hf;
				write_enable = 1'b1;
				regA = 4'hd;
				regB = 4'he;
				reg_imm = 1'b0;
				imm_val = 16'bx;
			end
			default: begin
				op = NOP;
				reg_reset = 0;
				write_select = 4'bx;
				write_enable = 1'b0;
				regA = 4'bx;
				regB = 4'bx;
				reg_imm = 1'bx;
				imm_val = 16'bx;
			end
		endcase
	end
endmodule
 