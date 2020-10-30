// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file creates an FSM to control basic R-type instructions.

module CPU_FSM(clk, rst, PC_enable, R_enable, LScntl, ALU_Mux_cntl, instruction, WE, flagModuleOut,irenable);
	input clk, rst;
	input [15:0] instruction;
	input [4:0] flagModuleOut;
	
	output reg PC_enable;
	output reg R_enable;
	output reg LScntl;
	output reg ALU_Mux_cntl;
	output reg WE;
	output reg irenable;
	
	// FSM States --------------------------------------------------------------------------------
	
	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[3:0] S0 = 4'h00, S1 = 4'h01, S2 = 4'h02, S3 = 4'h03, S4 = 4'h04, S5 = 4'h05;
						
	//Update state
	always @(posedge clk)
	begin
		if(rst) 
			y <= S0;
		
		else if(y == S4) 
			y <= S5;
		
		else if(y == S2 || y == S3 || y == S5) 
			y <= S0;
		
		else if(y < S2)
			y <= y + 1'b1;
			
		else 
		begin
			//Check to see if the current operation is a load instruction
			if (instruction[15:12] == 4'b0100 && instruction[7:4] == 4'b0000) 
				y <=S4;
			
			//Check to see if the current operation is a store instruction
			else if(instruction[15:12] == 4'b0100 && instruction[7:4] == 4'b0100) 
				y <= S3;
			
			//If neither it must be an R type instruction
			else 
				y <= S2;
				
		end
			
	end
	
	//Update output
	always @(y)
	begin
		case(y)
			S0: begin 
			// 0 disables incrementing PC
			PC_enable = 1'b0;
			// Register write enable
			R_enable = 1'b0;
			// Controls what address to read/write from in memory bus A. (0) from register B, (1) from PC. 
			LScntl = 1'b1;
			// Write enable for memory
			WE = 1'b0;
			// Writeback mux, 1 passes through alu result to wb, 0 changes to memory value.
			ALU_Mux_cntl = 1'b1;
			irenable = 1'b0;
			end
			
			S1: begin
			PC_enable = 1'b0;
			R_enable = 1'b0;
			LScntl = 1;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b0;
			end
			
			//This state is only selected if the instruction is R type
			S2: begin
			PC_enable = 1'b1;
			R_enable = 1'b0; 
			LScntl = 1'b1;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b1;
			end
		
			//This state is only selected if the instruction is store type
			S3: begin 
			PC_enable = 1'b1;
			R_enable = 1'b0;
			LScntl = 1'b0;
			WE = 1'b1;
			ALU_Mux_cntl = 1'bx;
			irenable = 1'b1;
			end
		
			//These two states are only selcted if the instruction is load type
			S4: begin 
			PC_enable = 1'b0;
			R_enable = 1'b0;
			LScntl = 1'b0;
			WE = 1'b0;
			ALU_Mux_cntl = 1'bx;
			irenable = 1'b1;
			end
		
			// Load the value from the address loaded in S4 into a register.
			S5: begin 
			PC_enable = 1'b1;
			R_enable = 1'b1;
			LScntl = 1'bx;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b1;
			end
			
			default: begin // Do nothing
			end
		endcase
	end
endmodule