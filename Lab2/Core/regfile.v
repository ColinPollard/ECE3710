// Author: Colin Pollard, Ian Lavin, Luke Majors, Mckay Mower
// Date: 9/17/2020
// This file represents an array of registers that are accessible using select lines.



// Single register instance.
module Register(in, wEnable, clk, r);
	 input [15:0] in;
	 input clk, wEnable;
	 output reg [15:0] r;
	 
 always @( posedge clk )
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
endmodule



// Register file, allows reading and writing from 16 registers.
module regfile(readA, readB, selectA, selectB, writeValue, writeSelect, writeEnable, clock);

// Output ports A and B
output reg [15:0] readA, readB;

// Value to write to register
input[15:0] writeValue;

// Enable writing to register
input writeEnable;

// Which register to read/write to/from.
input[3:0] writeSelect, selectA, selectB;

// Clock signal
input clock;

// Internal 16 bit signal to enable single registers.
reg [15:0] regEnable;

// Create a decoder to enable registers.
decoder decoder0(writeSelect, writeEnable, regEnable);

// Bank of registers
Register Inst0(write, regEnable[0], clock, r0);
Register Inst1(write, regEnable[1], clock, r1);
Register Inst2(write, regEnable[2], clock, r2);
Register Inst3(write, regEnable[3], clock, r3);
Register Inst4(write, regEnable[4], clock, r4);
Register Inst5(write, regEnable[5], clock, r5);
Register Inst6(write, regEnable[6], clock, r6);
Register Inst7(write, regEnable[7], clock, r7);
Register Inst8(write, regEnable[8], clock, r8);
Register Inst9(write, regEnable[9], clock, r9);
Register Inst10(write, regEnable[10], clock, r10);
Register Inst11(write, regEnable[11], clock, r11);
Register Inst12(write, regEnable[12], clock, r12);
Register Inst13(write, regEnable[13], clock, r13);
Register Inst14(write, regEnable[14], clock, r14);
Register Inst15(write, regEnable[15], clock, r15); 

// Muxes for selecting output a, b
mux16to1 muxA(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, selectA, readA);
mux16to1 muxB(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, selectB, readB);

endmodule