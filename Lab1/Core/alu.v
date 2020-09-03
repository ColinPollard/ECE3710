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

parameter ADD    = 8'b00000001;
parameter ADDI   = 8'b0101xxxx;
parameter ADDU   = 8'b00000110;
parameter ADDUI  = 8'b0110xxxx;
parameter ADDC   = 8'b00000111;
parameter ADDCU  = 8'b00000100;
parameter ADDCI  = 8'b00001000;
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
parameter SUBI   = 8'1001xxxx;
parameter CMP    = 8'b00001011;
parameter CMPI   = 8'b1011xxxx;


always @(A, B, Opcode)
begin
	case (Opcode)
	ADDU:
		begin
		{Flags[3], C} = A + B;
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 4'b0000) Flags[4] = 1'b1; 
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end
	ADD:
		begin
		C = A + B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;

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
		
	ADDI:
		begin
		{Flags[3], C} = A + B;
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 4'b0000) Flags[4] = 1'b1; 
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end
	ADDUI:
		begin
		C = A + B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;

		end
	ADDC:
		begin
		C = A - B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
		end
	ADDCU:
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
			ADDU:
		begin
		{Flags[3], C} = A + B;
		// perhaps if ({Flags[3], C} == 5'b00000) ....
		if (C == 4'b0000) Flags[4] = 1'b1; 
		else Flags[4] = 1'b0;
		Flags[2:0] = 3'b000;
		end
	ADDCI:
		begin
		C = A + B;
		if (C == 4'b0000) Flags[4] = 1'b1;
		else Flags[4] = 1'b0;
		if( (~A[3] & ~B[3] & C[3]) | (A[3] & B[3] & ~C[3]) ) Flags[2] = 1'b1;
		else Flags[2] = 1'b0;
		Flags[1:0] = 2'b00; Flags[3] = 1'b0;
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
		Flags = 4'b0000;
		C = 4'b0000;
		end
	AND:
		begin
		Flags = 4'b0000;
		C = A & B;
		end
	OR:
		begin
		Flags = 4'b0000;
		C = A | B;
		end
	XOR:
		begin
		Flags = 4'b0000;
		C = A ^ B;
		end
	NOT:
		begin
		Flags = 4'b0000;
		C = !A;
		end
	LSHI:
		begin
		
		end
	RSH:
		begin
		
		end
	RSHI:
		begin
		
		end
	default: 
		begin
			C = 4'b0000;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
