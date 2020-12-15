# ECE3710
The assembler for the 3710 computer design lab parses a	 text file containing mnemonics for the cpu instructions, and converts into a binary file that can be loaded onto the FPGA. The instructions are modeled from a simple RISC instruction set.c

Assembly File Rules:
    * Comments can be written using #. The comments must be after an instruction or on its own line.
    * Each instruction must be written on its own line.
    * Blank lines are okay
    * Lables must start with a '.'. These can be used in jump/branch instructions.
    * Immediate values must be preceded by a '$'

The text file with assembly code contains instructions of the form:
    OP Rsrc, Rdest (for R-type instructions)
    and
    OP imm, Rdest  (for I-type instructions)

For example, an add instruction might look like 
    ADD R1, R2
    ADDI $15, R7
where the contents of R1 are added to the contents of R2 and the result is stored back into R2.

Parsing the Instructions:
    The instructions will be processed one line at a time. First all preceding spaces are trimmed and text is converted to uppercase, then the instruction mneumonic is read. This will determine if the instruction is I-type or R-type. Note: all I type instructions end in 'I'. The assembly instruction will be converted to machine code based on its instruction type.

    Special Instructions:
    Some of the instructions are slightly different in the way they need to be read or written. These instructions are explained here.

    LSHI: 
        e.g. LSHI $3, R5
        This is encoded as an I-type instrucruction but the immediate is only 5 bits. The upper 3 bits are always set to zero. 
    
    Jump/Branch Instructions:
        The location to jump to can be specified by an immediate or a lable. Lables start with a '.'. In the jump or brach instruction, the . is not included. For example:
            ...code...
            jmp Lable1
            ...code...
            .Label1
            ...code to jump to...

    Encoder Instructions:
        The encoder instructions ENC1 and ENC2 are used to read positions from the rotary encoders and store them in a register. The instructions are of the form:
            ENC1 R1 #Stores value from encoder 1 into register R1
    
    Transmit Instruction:
        The transmit instructions is used to transmit data from a register to the arduino. The instructions is of the form:
            TRANSMIT R1 #Transmits the data stored in register R1
The instructions are written into a binary file. Each instruction is written onto its own line. 
Each instruction is 16 bits and encoded as follows:
    R-Type Instructions:
        [15-12]  [11-8]  [7-4]  [3-0]
        OP Code  Rdest  OP Ext  Rsrc
    I-Type Instructions:
        [15-12]  [11-8]  [7-0]
        OP Code  Rdest  Immediate