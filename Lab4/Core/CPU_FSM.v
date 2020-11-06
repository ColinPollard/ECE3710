// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file creates an FSM to control basic R-type instructions.

module CPU_FSM(clk, rst, PC_enable, PC_rst, R_enable, LScntl, ALU_Mux_cntl, instruction, WE, flagModuleOut,irenable, PC_mux, reg_rst);
	input clk, rst;
	input [15:0] instruction;
	input [4:0] flagModuleOut;
	
	output reg PC_enable;
	output reg R_enable;
	output reg LScntl;
	output reg ALU_Mux_cntl;
	output reg WE;
	output reg irenable, PC_mux, reg_rst, PC_rst;
	
	// FSM States --------------------------------------------------------------------------------
	
	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[3:0] S0 = 4'h0, S1 = 4'h1, S2 = 4'h2, S3 = 4'h3, S4 = 4'h4, S5 = 4'h5, S6 = 4'h6, STARTUP = 4'h7, NOP = 4'h8;
						
	//Update state
	always @(posedge clk)
	begin
		if(rst) 
			y <= STARTUP;
			
		else if(y == STARTUP || y == NOP)
			y <= 0;
			
		else if(y == S4) 
			y <= S5;
		
		else if(y == S2 || y == S3 || y == S5 || y == S6) 
			y <= S0;
		else if(y == S0)
			y <= S1;
		else 
		begin
			//Check to see if the current operation is a load instruction
			if (instruction[15:12] == 4'b0100 && instruction[7:4] == 4'b0000) 
				y <=S4;
			
			//Check to see if the current operation is a store instruction
			else if(instruction[15:12] == 4'b0100 && instruction[7:4] == 4'b0100) 
				y <= S3;
			
			//Check to see if the current operation is a branch instruction
			else if(instruction[15:12] == 4'b1100) begin
				if((instruction[11:8] == 4'b0000 && flagModuleOut[3]) || (instruction[11:8] == 4'b1100 && !flagModuleOut[3] && flagModuleOut[1]) || instruction[11:8] == 4'b1110)
					y <= S6;
				else
					y <= NOP;
			end	
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
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b0;
			PC_mux = 1'b0;
			reg_rst = 1'b0;
			PC_rst = 1'b0;
			end
			
			S1: begin
			PC_enable = 1'b0;
			R_enable = 1'b0;
			LScntl = 1'b1;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b1;
			PC_mux = 1'b0;
			reg_rst = 1'b0;
			PC_rst = 1'b0;
			end
			
			//This state is only selected if the instruction is a typical  R/I type
			S2: begin
			PC_enable = 1'b1;
			R_enable = 1'b1; 
			LScntl = 1'b1;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b0;
			PC_mux = 1'b0;
			reg_rst = 1'b0;
			PC_rst = 1'b0;
			end
		
			//This state is only selected if the instruction is store type
			S3: begin 
			PC_enable = 1'b1;
			R_enable = 1'b0;
			LScntl = 1'b0;
			WE = 1'b1;
			ALU_Mux_cntl = 1'bx;
			irenable = 1'b1;
			PC_mux = 1'b0;
			reg_rst = 1'b0;
			PC_rst = 1'b0;
			end
		
			//These two states are only selcted if the instruction is load type
			S4: begin 
			PC_enable = 1'b0;
			R_enable = 1'b0;
			LScntl = 1'b0;
			WE = 1'b0;
			ALU_Mux_cntl = 1'bx;
			irenable = 1'b1;
			PC_mux = 1'b0;
			reg_rst = 1'b0;
			PC_rst = 1'b0;
			end
		
			// Load the value from the address loaded in S4 into a register.
			S5: begin 
			PC_enable = 1'b1;
			R_enable = 1'b1;
			LScntl = 1'bx;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b1;
			PC_mux = 1'b0;
			reg_rst = 1'b0;
			PC_rst = 1'b0;
			end
			
			// Increment the program counter with the brach displacement
			S6: begin 
			PC_enable = 1'b1;
			R_enable = 1'b0;
			LScntl = 1'b1;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b0;
			PC_mux = 1'b1;
			reg_rst = 1'b0;
			PC_rst = 1'b0;
			end
			
			// Startup state to initialize registers
			STARTUP: begin 
			PC_enable = 1'b0;
			R_enable = 1'b0;
			LScntl = 1'b0;
			WE = 1'b0;
			ALU_Mux_cntl = 1'b0;
			irenable = 1'b0;
			PC_mux = 1'b0;
			reg_rst = 1'b1;
			PC_rst = 1'b1;
			end
			// Do nothing but update PC
			NOP: begin
				PC_enable = 1'b1;
				R_enable = 1'b0;
				LScntl = 1'b0;
				WE = 1'b0;
				ALU_Mux_cntl = 1'b0;
				irenable = 1'b0;
				PC_mux = 1'b0;
				reg_rst = 1'b0;
				PC_rst = 1'b0;				
			end
			default: begin 
				PC_enable = 1'b0;
				R_enable = 1'b0;
				LScntl = 1'b0;
				WE = 1'b0;
				ALU_Mux_cntl = 1'b0;
				irenable = 1'b0;
				PC_mux = 1'b0;
				reg_rst = 1'b0;
				PC_rst = 1'b0;			
			end
		endcase
	end
endmodule