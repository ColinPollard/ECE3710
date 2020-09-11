//Opcodes

parameter ADD    = 8'b00000101;
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

parameter LSH    = 8'b10000100;
parameter LSHI   = 8'b1000000x;
parameter RSH    = 8'b01001111;
parameter RSHI   = 8'b10000101;
parameter ALSH   = 8'b10000111;
parameter ARSH   = 8'b10001xxx;
