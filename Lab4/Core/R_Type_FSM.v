// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file creates an FSM to control basic R-type instructions.

module R_Type_FSM(clk, rst, PC_enable, R_enable, R_or_I,LScntl,ALU_Mux_cntl,instruction,WE);
	input clk, rst;
	input [15:0] instruction;
	
	output reg PC_enable;
	output reg R_enable;
	output reg R_or_I; //0 for R, 1 for I
	output reg LScntl;
	output reg ALU_Mux_cntl;
	output reg WE;
	
	// FSM States --------------------------------------------------------------------------------
	
	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[3:0] S0 = 4'h00, S1 = 4'h01, S2 = 4'h02, S3 = 4'h03, S4 = 4'h04, S5 = 4'h05;
						
	//Update state
	always @(posedge clk)
	begin
		if(rst) y <= S0;
		else if(y == S2)
			y <= S0;
		else begin
			y <= y + 1'b1;
		end
	end
	
	//Update output
	always @(y)
	begin
		case(y)
			S0: begin 
			PC_enable = 1'b0;
			R_enable = 1'b0;
			R_or_I = 1'bx;
			LScntl = 1;
			end
			
			S1: begin
			PC_enable = 1'b0;
			R_enable = 1'b0;
			R_or_I = 1'bx;
			LScntl = 1;
			end
			
			//This state is only selected if the instruction is R type
			S2: begin
			PC_enable = 1'b1;
			R_enable = 1'b0; //
			R_or_I = 1'bx; //
			LScntl = 1;
			end
		
			//This state is only selected if the instruction is store type
			S3: begin 
			PC_enable = 1'b1;
			R_enable = 1'b1;
			R_or_I = 1'bx;
			LScntl = 0;
			end
		
			//These two states are only selcted if the instruction is load type
			S4: begin 
			PC_enable = 1'b0;
			R_enable = 1'b0;
			R_or_I = 1'bx;
			end
		
			S5: begin 
			PC_enable = 1'b0;
			R_enable = 1'b0;
			R_or_I = 1'bx;
			end
			
			default: begin // Do nothing
			end
		endcase
	end
endmodule