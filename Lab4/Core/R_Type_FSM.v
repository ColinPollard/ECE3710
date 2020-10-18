// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file creates an FSM to control basic R-type instructions.

module R_Type_FSM(clk, rst, PC_enable, R_enable, R_or_I);
	input clk, rst;
	
	output reg PC_enable;
	output reg R_enable;
	output reg R_or_I; //0 for R, 1 for I
	
	// FSM States --------------------------------------------------------------------------------
	
	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[3:0] S0 = 4'h00, S1 = 4'h01, S2 = 4'h02;
						
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
	// Expected output is: 1, 2, 3, 4, 5, 0.
	always @(y)
	begin
		case(y)
			S0: begin 
			PC_enable = 1'b0;
			R_en = 1'b0;
			R_or_I = 1'bx;
			end
			S1: begin
			PC_enable = 1'b0;
			R_en = 1'b0;
			R_or_I = 1'bx;
			end
			S2: begin
			PC_enable = 1'b1;
			R_en = 1'b0; //
			R_or_I = 1'bx; //
			end
			
			default: begin // Do nothing
			end
		endcase
	end
endmodule