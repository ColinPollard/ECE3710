// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/1/2020
// This module demonstrates and tests reading and writing to the memory module.

module memoryFSM(clk, rst, seg7, dataInA, dataInB, addressA, addressB, weA, weB, clkA, clkB, dataOutA, dataOutB, initializeMemory);
	
	// Clock to fsm, reset state to 0.
	input clk, rst;
	
	// These are the data outputs from the bram, and inputs to the fsm (fetch result).
	input [15:0] dataOutA, dataOutB;
	
	// Write enables, clocks for the bram, and initializememory call.
	output reg weA, weB, clkA, clkB, initializeMemory;
	
	// Data input to bram, output from fsm (write to memory).
	output reg [15:0] dataInA, dataInB;
	
	// Addresses to access/write to.
	output reg [7:0] addressA, addressB;
	
	// Seven segment output for hardware demo.
	output reg [6:0] seg7;

	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[4:0] S0 = 5'h00, S1 = 5'h01, S2 = 5'h02, S3 = 5'h03, S4 = 5'h04, S5 = 5'h05, S6 = 5'h06, S7 = 5'h07,
						S8 = 5'h08, S9 = 5'h09, S10 = 5'h0a, S11 = 5'h0b, S12 = 5'h0c, S13 = 5'h0d, S14 = 5'h0e, S15 = 5'h0f,
						S16 = 5'h10;
						
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
			S0: begin // Initialize all memory according to the mif file.
				

			end
			S1: begin //Set reg0 to 1

			end
			S2: begin //Set reg1 to 2

			end
			S3: begin //reg2 = reg0 + reg1

			end
			S4: begin //reg3 = reg1 + reg2

			end
			S5: begin //reg4 = reg2 + reg3

			end
			S6: begin //reg5 = reg3 + reg4

			end
			S7: begin //reg6 = reg4 + reg5

			end
			S8: begin //reg7 = reg5 + reg6

			end
			S9: begin //reg8 = reg6 + reg7

			end
			S10: begin //reg9 = reg7 + reg8

			end
			S11: begin //reg10 = reg8 + reg9

			end
			S12: begin //reg11 = reg9 + reg10

			end
			S13: begin //reg12 = reg10 + reg11

			end
			S14: begin //reg13 = reg11 + reg12

			end
			S15: begin //reg14 = reg12 + reg13

			end
			S16: begin //reg15 = reg13 + reg14

			end
			default: begin

			end
		endcase
	end	

endmodule