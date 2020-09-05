/*
 * Lab 1 ALU design
 *	Group 4
 *
 *
 */


`timescale 1ns / 1ps

module alu( A, B, C, Opcode, Flags
    );
input [15:0] A, B;
input [7:0] Opcode;
output reg [15:0] C;
output reg [4:0] Flags;

// "The only ones which can change the program status register (PSR) are the arithmetic instructions ADD, ADDI, SUB,SUBI, CMP, CMPI."
// Flags[0] = Carry bit
// Flags[1] = Low Flag
// Flags[2] = Flag Bit
// Flags[3] = Zero Bit
// Flags[4] = Negative Bit

parameter ADD    = 8'b00000001;
parameter ADDI   = 8'b0101xxxx;

parameter ADDU   = 8'b00000110;
parameter ADDUI  = 8'b0110xxxx;

parameter ADDC   = 8'b00000111;
parameter ADDCI  = 8'b0111xxxx;

parameter ADDCU  = 8'b00000100;
parameter ADDCUI = 8'b00001000;

parameter SUB    = 8'b00001001;
parameter SUBI   = 8'b1001xxxx;

parameter CMP    = 8'b00001011;
parameter CMPI   = 8'b1011xxxx;
parameter CMPUI  = 8'b00001100;

parameter NOP    = 8'b00000000;
parameter AND    = 8'b00000001;
parameter OR     = 8'b00000010;
parameter XOR    = 8'b00000011;
parameter NOT    = 8'b00001111;
parameter LSH    = 8'b00000111;
parameter LSHI   = 8'b1000000x;
parameter RSH    = 8'b01001111;
parameter RSHI   = 8'b10000101;
parameter ALSH   = 8'b10000111;
parameter ARSH   = 8'b10001xxx;


always @(A, B, Opcode)
begin
	case (Opcode)
	
	// Add Signed or Signed Immediate, changes flags.
	ADD,
	ADDI:
		begin
		C = A + B;
		if (C == 16'b0000000000000000) Flags[3] = 1'b1;
		else Flags[3] = 1'b0;
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[4] = 1'b0;
		end
		
	//ADDC (or ADDCI) does the same as ADD (signed) except the C flag is also added in. It affects the same flags
	ADDC,
	ADDCI:
		begin
		// Add A + B + Carry bit
		C = A + B + Flags[0];
		
		// If zero result set Z bit
		if (C == 16'b0000000000000000) Flags[3] = 1'b1;
		else Flags[3] = 1'b0;
		
		// If signed overflow occured set Flag bit
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		
		// All other flags 0.
		Flags[1:0] = 2'b00; Flags[4] = 1'b0;
		end
	
	// Add Unsigned or Unsigned Immediate
	// According to the ISA, these do the same thing as ADD but do not affect the PSR.
	ADDU,
	ADDUI:
		begin
		C = A + B;
		Flags = 5'b00000;
		end
	
	//ADDCU (or ADDCUI) does the same as ADDU (unsigned) except the C flag is also added in. No changes to flags.
	ADDCU,
	ADDCUI:	
		begin
		// Set the carry bit if result is 17 bits
		{Flags[0], C} = A + B + Flags[0];
		
		Flags = 5'b00000;
		end
		
	SUB:
		begin
		C = A - B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end
	CMP:
		begin
		if( $signed(A) < $signed(B) ) Flags[1:0] = 2'b11;
		else Flags[1:0] = 2'b00;
		C = 4'b0000;
		Flags[4:2] = 3'b000;
		// both positive or both negative
		/*if( A[3] == B[3] )
		begin
			if (A < B) Flags[1:0] = 2'b11;
			else Flags[1:0] = 2'b00;
		end
		else if (A[3] == 1'b0) Flags[1:0] = 2'b00;
		else Flags[1:0] = 2'b01;
		Flags[4:2] = 3'b000;
		
		// C = ?? if I don;t specify, then I'm in trouble.
		C = 4'b0000;
		*/
		end
	SUBI:
		begin
		C = A - B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end
		
	CMPI:
		begin
		
		end
	CMPUI:
		begin
		
		end
	NOP:
		begin
		Flags = 5'b0000;
		C = 16'b0000;
		end
	AND:
		begin
		Flags = 5'b0000;
		C = A & B;
		end
	OR:
		begin
		Flags = 5'b0000;
		C = A | B;
		end
	XOR:
		begin
		Flags = 5'b0000;
		C = A ^ B;
		end
	NOT:
		begin
		Flags = 5'b0000;
		C = !A;
		end
	LSH:
		begin
		Flags = 5'b00000;
		C = A << 1;
		end
	LSHI:
		begin
		Flags = 5'b00000;
		C = A << B;
		end
	RSH:
		begin
		Flags = 5'b00000;
		C = A >> 1;
		end
	RSHI:
		begin
		Flags = 5'b00000;
		C = A >> B;
		end
	default: 
		begin
			C = 4'b0000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
