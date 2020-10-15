// Author: Colin Pollard, Ian Lavin
// Date: 10/15/2020
// This file creates an FSM to control basic R-type instructions.

module R_Type_FSM(clk, rst, dataInA, dataInB, addressA, addressB, weA, weB, dataOutA, dataOutB, write_enable, write_select, regA, regB, op, reg_imm, reg_reset, imm_val);
	input clk, rst;

	// Which register to write back into
	output [3:0] write_select;

	// Which registers to read into ALU.
	output [3:0] regA, regB;

	// op code to alu
	output [7:0] op;

	// Selects ALU B input. 0=RegisterB, 1=imm_val
	output reg_imm;

	// Reset all registers in the ALU datapath.
	output reg_reset;

	// Enable writeback into register.
	output write_enable;

	// Optional immediate value for ALU B input. Only goes through if reg_imm is HIGH.
	output [15:0] imm_val;

	output dataInA, dataInB;

	
	// FSM States --------------------------------------------------------------------------------
	
	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[3:0] S0 = 4'h00, S1 = 4'h01, S2 = 4'h02, S3 = 4'h03, S4 = 4'h04, S5 = 4'h05;
						
	//Update state
	always @(posedge clk)
	begin
		if(rst) y <= S0;
		else if(y == S5)
			y <= y;
		else begin
			y <= y + 1'b1;
		end
	end
	
	
	//Update output
	// Expected output is: 1, 2, 3, 4, 5, 0.
	always @(y)
	begin
		case(y)
			S0: begin // Read from address 0 (expect 1) on A
					
				weA = 1'b0;
				weB = 1'b0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				addressB = 10'd0;
				
				// Set the address to read from
				addressA = 10'd0;
				
				// Set seg7 output to first three bits of result
				displaySelect = 1'b0;
			end
			S1: begin // Read from address 1 (expect 2) on B
					
				weA = 1'b0;
				weB = 1'b0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				addressA = 8'b0;
				
				// Set the address to read from
				addressB = 10'd1;
				
				// Set seg7 output to B
				displaySelect = 1'b1;
			end
			S2: begin // Write to address 0 on A, read from address 2 on B
			
				weB = 1'b0;
				dataInB = 16'd0;
			
				// Enable writing on A
				weA = 1'b1;
				
				// Write value is 4
				dataInA = 16'd4;
				
				// Write address is 0
				addressA = 10'd0;
				
				// Read Address is 3
				addressB = 10'd2;
				
				// Get output
				displaySelect = 1'b1;
				
			end
			S3: begin // Read from address 0 on A, write to address 513 on B
			
				weA = 1'b0;
				dataInA = 16'b0;
				
				// Enable Writing on B
				weB = 1'b1;
				
				// Write value is 5
				dataInB = 16'd5;
				
				// Write address of B is 513
				addressB = 10'd513;
				
				// Read address on A is 0
				addressA = 10'd0;
				
				// Get Output
				displaySelect = 1'b0;

			end
			S4: begin // Read from address 513 on A, reset value at address 0 to 1 on B.
			
				weA = 1'b0;
				weB = 1'b1;
				addressA = 10'd513;
				addressB = 10'd0;
				dataInA = 16'bx;
				dataInB = 16'd1;
				displaySelect = 1'b0;

			end
			S5: begin // Reset value at address 513 to 0 on A. Read from 5 on B.
			
				weA = 1'b1;
				weB = 1'b0;
				addressA = 10'd513;
				addressB = 10'd5;
				dataInA = 16'd0;
				dataInB = 16'dx;
				displaySelect = 1'b1;

			end
			
			default: begin // Do nothing
				weA = 1'b0;
				weB = 1'b0;
				addressA = 10'd0;
				addressB = 10'd0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				displaySelect = 1'b0;
			end
		endcase
endmodule