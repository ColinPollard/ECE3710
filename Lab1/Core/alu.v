/*
 * Authors:
	Colin Pollard, Ian Lavin, Luke Majors, Mckay Mower
 * 
 * Date Created:
	9/3/2020
	
 * 16-bit EECS 427 ALU Design
	This project represents a 16-bit risc ALU that implements the baseline standard for
	the EECS 427. It utilizes an internal 5-bit flags register, and assumes that immediate
	sign extentions are handled outside of the ALU.
 */


`timescale 1ns / 1ps

module alu( A, B, C, Opcode, Flags);
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
	
	// Adding operations -----------------------------------------------------------------------------------------------------------------------------
	
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
		C = A + B + Flags[0];
		
		// Set all flags to 0
		Flags = 5'b00000;
		end
		
		
	// Subtracting operations ------------------------------------------------------------------------------------------------------------------------
	
	// Subtract or Subtract immediate affects PSR.
	SUB,
	SUBI:
		begin
		C = A - B;
		
		// If result is zero set zero flag.
		if (C == 16'b0000000000000000) Flags[3] = 1'b1;
		else Flags[3] = 1'b0;
		
		// If signed subtraction results in overflow set flag bit.
		if( (~A[15] & ~B[15] & C[15]) | (A[15] & B[15] & ~C[15]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		
		// All other flags zero.
		Flags[1:0] = 2'b00; Flags[4] = 1'b0;
		end
		
	// "CMP and CMPI perform the same operations as SUB, SUBI but affect different PSR flags (see below) and do not write back the result."
	// "Set the Z flag if the result is zero, set the L flag if Rsrc/Imm > Rdest when the operands are treated as unsigned numbers."
	CMP,
	CMPI:
		begin
		// Set the low flag if A < B signed
		if( $signed(A) < $signed(B) ) Flags[1] = 1'b1;
		else Flags[1] = 1'b0;
		
		// Set zero flag if result is zero.
		if (A == B) Flags[3] = 1'b1;
		else Flags[3] = 1'b0;
		
		// There is no write back, so we will just set C to 0
		C = 4'b0000;
		
		// All other flags zero.
		Flags[0] = 1'b0;
		Flags[2] = 1'b0;
		Flags[4] = 1'b0;
		end
	
	
	// "Set the Z flag if the result is zero, set the N flag if Rsrc/Imm > Rdest when the operands are treated as two’s complement numbers"
	CMPU,
	CMPUI:
		begin
		// Set the N flag if A < B signed
		if(A < B) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		
		// Set zero flag if result is zero.
		if (A == B) Flags[3] = 1'b1;
		else Flags[3] = 1'b0;
		
		// There is no write back, so we will just set C to 0
		C = 4'b0000;
		
		// All other flags zero.
		Flags[2:0] = 3'b000;
		end
		
	// Bitwise Operations ----------------------------------------------------------------------------------------------------------------------------
	
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
	
	// Shifting Operations ---------------------------------------------------------------------------------------------------------------------------	
	
	// Shift left by 1, not specified in ISA but is specified in Lab1-20.pdf
	LSH:
		begin
		Flags = 5'b00000;
		C = A << 1;
		end
	
	// Shift left by immediate. Range is -15 to 15 (5 bits)
	LSHI:
		begin
		Flags = 5'b00000;
		C = A << $signed(B[4:0]);
		end
		
	// Right shift by 1
	RSH:
		begin
		Flags = 5'b00000;
		C = A >> 1;
		end
	
	// Right shift by immediate. Range is -15 to 15 (5 bits)
	RSHI:
		begin
		Flags = 5'b00000;
		C = A >> $signed(B[4:0]);
		end
		
	// Arithmetic left shift
	ALSH:
		begin
		Flags = 5'b00000;
		C = A <<< $signed(B[4:0]);
		end
	
	// Arithmetic right shift
	ARSH:
		begin
		Flags = 5'b00000;
		C = A >>> $signed(B[4:0]);
		end
		
	// Default case ----------------------------------------------------------------------------------------------------------------------------------
		
	default: 
		begin
			C = 16'b0000000000000000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
