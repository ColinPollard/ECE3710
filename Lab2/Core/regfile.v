// Author: Colin Pollard, Ian Lavin, Luke Majors, Mckay Mower
// Date: 9/17/2020
// This file represents an array of registers that are accessible using select lines.



// Single register instance.
module Register(in, wEnable, clk, r, reset);
	 input [15:0] in;
	 input clk, wEnable, reset;
	 output reg [15:0] r;
	 
 always @( posedge clk )
	begin
		if(reset) r <= 16'h0000;
		else 
		begin
			if (wEnable)
			begin
				r <= in;
			end
			else
			begin
				r <= r;
			end
		end
	end
endmodule



// Register file, allows reading and writing from 16 registers.
module regfile(readA, readB, selectA, selectB, writeValue, writeSelect, writeEnable, clock, reset);

// Output ports A and B
output [15:0] readA, readB;

// Value to write to register
input[15:0] writeValue;

// Enable writing to register
input writeEnable, reset;

// Which register to read/write to/from.
input[3:0] writeSelect, selectA, selectB;

// Clock signal
input clock;

// Internal 16 bit signal to enable single registers.
wire [15:0] regEnable, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

// Create a decoder to enable registers.
decoder decoder0(writeSelect, writeEnable, regEnable);

// Bank of registers
Register Inst0(writeValue, regEnable[0], clock, r0, reset);
Register Inst1(writeValue, regEnable[1], clock, r1, reset);
Register Inst2(writeValue, regEnable[2], clock, r2, reset);
Register Inst3(writeValue, regEnable[3], clock, r3, reset);
Register Inst4(writeValue, regEnable[4], clock, r4, reset);
Register Inst5(writeValue, regEnable[5], clock, r5, reset);
Register Inst6(writeValue, regEnable[6], clock, r6, reset);
Register Inst7(writeValue, regEnable[7], clock, r7, reset);
Register Inst8(writeValue, regEnable[8], clock, r8, reset);
Register Inst9(writeValue, regEnable[9], clock, r9, reset);
Register Inst10(writeValue, regEnable[10], clock, r10, reset);
Register Inst11(writeValue, regEnable[11], clock, r11, reset);
Register Inst12(writeValue, regEnable[12], clock, r12, reset);
Register Inst13(writeValue, regEnable[13], clock, r13, reset);
Register Inst14(writeValue, regEnable[14], clock, r14, reset);
Register Inst15(writeValue, regEnable[15], clock, r15, reset); 

// Muxes for selecting output a, b
mux16to1 muxA(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, selectA, readA);
mux16to1 muxB(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, selectB, readB);

endmodule