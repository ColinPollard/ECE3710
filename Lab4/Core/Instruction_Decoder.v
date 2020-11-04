// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This module decodes instructions from memory.

module Instruction_Decoder(instruction, op, rDest, rSrc, immediate, r_or_i);

	// Incoming instruction, can be R or I type.
	input [15:0] instruction; //data out

	// Op code is 4 bits with possible extra four bits if R type. Immediate for I type.
	output reg [7:0] op;
	output reg [15:0] immediate;

	// Register selects.
	output reg [3:0] rDest, rSrc;
	
	// MUX control wire for selecting a value from register or immediate to ALU input B.
	output reg r_or_i;

	// Update on new instruction.
	always @(instruction)
	begin
		// if bits 15-12 are 0000, R-type
		if (instruction[15:12] == 4'b0000)
		begin
			// Op code is 8 bits, 4 are in the immediate high
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			// In immediate low
			rSrc = instruction[3:0];
			// Don't care
			immediate = 16'bx;
			r_or_i = 1'b0;
		end
		//LSH
		else if(instruction[15:12] == 4'b1000 && instruction[7:4] == 4'b0100)
		begin
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			rSrc = instruction[3:0];
			immediate = 16'bx;
			r_or_i = 1'b0;
		end
		//ASH
		else if(instruction[15:12] == 4'b1000 && instruction[7:4] == 4'b0110)
		begin 
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			rSrc = instruction[3:0];
			immediate = 16'bx;
			r_or_i = 1'b0;
		end
		//RSH
		else if(instruction[15:12] == 4'b0100 && instruction[7:4] == 4'b1111)
		begin
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			rSrc = instruction[3:0];
			immediate = 16'bx;
			r_or_i = 1'b0;
		end
		//WAIT/NOP
		else if(instruction[15:12] == 4'b0000 && instruction[7:4] == 4'b0000)
		begin
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			rSrc = instruction[3:0];
			immediate = 16'bx;
			r_or_i = 1'b0;
		end
		//LOAD
		else if(instruction[15:12] == 4'b0100 && instruction[7:4] == 4'b0000)
		begin
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			rSrc = instruction[3:0];
			immediate = 16'bx;
			r_or_i = 1'b0;
		end
		//STORE
		else if(instruction[15:12] == 4'b0100 && instruction[7:4] == 4'b0100)
		begin
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			rSrc = instruction[3:0];
			immediate = 16'bx;
			r_or_i = 1'b0;
		end
		
		//Branch/Jump instruction
		else if(instruction[15:12] == 4'b1100)
		begin
			op = {instruction[15:12], instruction[11:8]};
			rDest = 4'bx;
			rSrc = 4'bx;
			immediate = $signed(instruction[7:0]);
			r_or_i = 1'b1;
		end
		
		// I-Type instruction
		else
		begin
			// Op code is 4 bits, set last 4 to don't care
			op = {instruction[15:12], 4'bx};
			rDest = instruction[11:8];	
			// Don't care
			rSrc = 4'bx;
			// Sign extend to 16 bits from 8 bit instruction.
			immediate = $signed(instruction[7:0]);
			r_or_i = 1'b1;
		end
		
	end
endmodule 