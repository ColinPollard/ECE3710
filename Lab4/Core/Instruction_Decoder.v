// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This module decodes instructions from memory.

module Instruction_Decoder(instruction, op, rDest, rSrc, immediate);

	// Incoming instruction, can be R or I type.
	input [15:0] instruction;

	// Op code is 4 bits with possible extra four bits if R type. Immediate for I type.
	output reg [7:0] op, immediate;

	// Register selects.
	output reg [3:0] rDest, rSrc;

	// Update on new instruction.
	always @(instruction)
	begin
		// Determine if it is an R-type or I-type
		
		// if bits 15-12 are 0000, R-type
		if (instruction[15:12] == 4'b0)
		begin
			// Op code is 8 bits, 4 are in the immediate high
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			// In immediate low
			rSrc = instruction[3:0];
			// Don't care
			immediate = 8'd0;
		end
		
		// Shift Instructions
		else if(instruction[15:12] == 4'b1000)
		begin
			
			//R-Type (LSH, ASHU, RSH)
			if(instruction[7:4] == 4'b0100 || instruction[7:4] == 4'b0110 || instruction[7:4] == 4'b0101)
			begin
				op = {instruction[15:12], instruction[7:4]};
				rDest = instruction[11:8];
				rSrc = instruction[3:0];
				immediate = 8'd0;
			end
			
			//LSHI, ASHUI
			else if(instruction[7:3] == 3'b000 || instruction[7:3] == 3'b001)
			begin
				op = {instruction[15:12], instruction[7:3], 1'b0};
				rDest = instruction[11:8];
				rSrc = 4'd0;
				immediate = {4'b0, instruction[3:0]};
			end
			
			// Base case
			else
			begin
				op = 8'd0;
				rDest = 4'd0;
				rSrc = 4'd0;
				immediate = 8'd0;
			end	
		end
		
		// Custom RSH
		else if({instruction[15:12], instruction[7:4]} == 8'b01001111)
		begin
			op = {instruction[15:12], instruction[7:4]};
			rDest = instruction[11:8];
			rSrc = instruction[3:0];
			immediate = 8'd0;
		end
		
		// I-Type
		else
		begin
			// Op code is 4 bits, set last 4 to don't care
			op = {instruction[15:12], 4'b0};
			rDest = instruction[11:8];	
			// Don't care
			rSrc = 4'd0;
			immediate = instruction[7:0];
		end
		
	end
endmodule 