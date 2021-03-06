`timescale 1ns / 1ps

module alutest;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [7:0] Opcode;

	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;

	integer i,passed,total,cin;
	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.A(A), 
		.B(B), 
		.C(C), 
		.Opcode(Opcode), 
		.Flags(Flags)
	);

	initial begin
		//$monitor("A: %0d, B: %0d, C: %0d, Flags[4:0]: %b, time:%0d", A, B, C, Flags[4:0], $time );
//Instead of the $display stmt in the loop, you could use just this
//monitor statement which is executed everytime there is an event on any
//signal in the argument list.

		// Initialize Inputs
		A = 0;
		B = 0;
		Opcode = 8'b00000000;
		passed = 0;
		total = 0;
		#10

		// Addition Tests
		
			//Add/Addi
			begin
			Opcode = 8'b00000101;
			
			//Zero flag tests
			$display("ADD/ADDI Tests ----------------------------");
			$display("\tZero flag testing:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'b0000000000000000;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'b1111111111111111; B = 16'b0000000000000001;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			//overflow testing
			$display("\n\tOverflow flag testing:");
			
			total=total+1;
			A = 16'b1000000000000000; B = 16'hffff; //-32768 + -1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'h7fff; B = 16'h0001; //32767 + 1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			end
			
			//Addu/Addui
			begin
			Opcode = 8'b00000110;
			
			//Carry Flag Tests
			$display("ADDU/ADDUI Tests ----------------------------");
			$display("\tCarry flag testing:");
			
			total=total+1;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			if(Flags[0] == 1 && Flags[4:1] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
		
			total=total+1;
			A = 16'b1111111111111111; B = 16'b0000000000000001;
			#10
			if(Flags[0] == 1 && Flags[4:1] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
			
			//No overflow testing
			$display("\n\tNo overflow flag testing:");
			
			total=total+1;
			A = 16'b0100000000000000; B = 16'b0100000000000000;
			#10
			if(Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
		
			//Test clear carry
			$display("\n\tClear carry testing:");
			
			total=total+1;
			A = 0; B = 0; 
			#10
			if(Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
			end
			
			//Addc/Addci
			begin
				
			Opcode = 8'b00000111;
			
			//Zero flag tests
			$display("ADDC/ADDCI Tests ----------------------------");
			$display("\tZero flag testing without carry:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'b0000000000000000;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'b1111111111111111; B = 16'b0000000000000001;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			//overflow testing
			$display("\n\tOverflow flag testing without carry:");
			
			total=total+1;
			A = 16'b1000000000000000; B = 16'hffff; //-32768 + -1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'h7fff; B = 16'h0001; //32767 + 1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			//Zero flag tests with carry
			$display("\tZero flag testing with carry:");
			
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000111;
			A = 16'b0000000000000000; B = 16'b0000000000000000;
			#10
			if(C == 1 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
		
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000111;
			A = 16'b1111111111111111; B = 16'b0000000000000000;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
			
			//overflow testing with carry
			$display("\n\tOverflow flag testing with carry:");
			
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000111;
			A = 16'b1000000000000000; B = 16'hfffe; //-32768 + -2 + 1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
		
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000111;
			A = 16'h7fff; B = 16'h0000; //32767 + 1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
			end
		
			//Addcu/Addcui
			begin			
			Opcode = 8'b00000100;
			
			//Carry Flag Tests without carry
			$display("ADDU/ADDUI Tests ----------------------------");
			$display("\tCarry flag testing without carry:");
			
			total=total+1;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			if(Flags[0] == 1 && Flags[4:1] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
		
			total=total+1;
			A = 16'b1111111111111111; B = 16'b0000000000000001;
			#10
			if(Flags[0] == 1 && Flags[4:1] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
			
			//No overflow testing
			$display("\n\tNo overflow flag testing without carry:");
			
			total=total+1;
			A = 16'b0100000000000000; B = 16'b0100000000000000;
			#10
			if(Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
		
			//Test clear carry
			$display("\n\tClear carry testing without carry:");
			
			total=total+1;
			A = 0; B = 0; 
			#10
			if(Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d = %0d, Flags[4:0]: %b", A, B, C, Flags[4:0]);
			
			$display("\tCarry flag testing with carry:");
			
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000100;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			if(Flags[0] == 1 && Flags[4:1] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
		
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000100;
			A = 16'b1111111111111111; B = 16'b0000000000000000;
			#10
			if(Flags[0] == 1 && Flags[4:1] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
			
			//No overflow testing
			$display("\n\tNo overflow flag testing with carry:");
			
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000100;
			A = 16'b0100000000000000; B = 16'b0011111111111111;
			#10
			if(Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
		
			//Test clear carry with carry
			$display("\n\tClear carry testing with carry:");
			
			total=total+1;
			Opcode = 8'b00000110;
			A = 16'b1000000000000000; B = 16'b1000000000000000;
			#10
			cin = Flags[0];
			Opcode = 8'b00000100;
			A = 0; B = 0; 
			#10
			if(Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d + %0d + %0b = %0d, Flags[4:0]: %b", $signed(A), $signed(B), cin, $signed(C), Flags[4:0]);
			end
		// Subtraction Tests
			//Sub/Subi
			begin
			Opcode = 8'b00001001;
			
			//Zero flag tests
			$display("SUB/SUBI Tests ----------------------------");
			$display("\tZero flag testing:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'b0000000000000000;
			#10
			if(C == 0 && Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d - %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'h0001; B = 16'h0001;
			#10
			if(C == 0 && Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d - %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			//overflow testing
			$display("\n\tOverflow flag testing:");
			
			total=total+1;
			A = 16'b1000000000000000; B = 16'h0001; //-32768 - 1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d - %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'h7fff; B = 16'hffff; //32767 - -1
			#10
			if(Flags[2] == 1 && Flags[4:3] == 2'b00 && Flags[1:0] == 2'b00) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d - %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			//General output testing
			$display("\n\tGeneral output testing:");
			
			total=total+1;
			A = 16'h0005; B = 16'h0003; //5-3
			#10
			if(C == 2 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d - %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'h0005; B = 16'hfffd; //5 - -3
			#10
			if(C == 8 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d - %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			end
			
		// Compare Tests
			//Cmp/Cmpi
			begin
			Opcode = 8'b00001011;
			
			//Zero flag tests
			$display("CMP/CMPI Tests ----------------------------");
			$display("\tZero flag / equality testing:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'b0000000000000000;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
		
			total=total+1;
			A = 16'h4f56; B = 16'h4f56;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
			
			//low flag testing
			$display("\n\tLow flag testing:");
			
			total=total+1;
			A = 16'b1000000000000000; B = 16'h7fff;
			#10
			if(Flags[1] == 1 && Flags[4:2] == 2'b000 && Flags[0] == 1'b0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
		
			total=total+1;
			A = 16'h0005; B = 16'h0020;
			#10
			if(Flags[1] == 1 && Flags[4:2] == 2'b000 && Flags[0] == 1'b0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
			end
			
			//CMPU/CMPUI
			begin
			Opcode = 8'b00001100;
			
			//Zero flag tests
			$display("CMPU/CMPUI Tests ----------------------------");
			$display("\tZero flag / equality testing:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'b0000000000000000;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
		
			total=total+1;
			A = 16'h4f56; B = 16'h4f56;
			#10
			if(Flags[3] == 1 && Flags[4] == 0 && Flags[2:0] == 3'b000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
			
			//Neg flag testing
			$display("\n\tNegative flag testing:");
			
			total=total+1;
			A = 16'b0100000000000000; B = 16'hffff;
			#10
			if(Flags[4] == 1 && Flags[3:0] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
		
			total=total+1;
			A = 16'h0005; B = 16'h0020;
			#10
			if(Flags[4] == 1 && Flags[3:0] == 4'b0000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\tCompare %0d and %0d, Flags[4:0]: %b", $signed(A), $signed(B), Flags[4:0]);
			end
			
			
			//Logical Operations
			begin
			
			//Logical Operations
			$display("Logical Tests ----------------------------");
			
			//AND
			$display("\tAND:");
			Opcode = 8'b00000001;
			total=total+1;
			A = 16'hffff; B = 16'h0001;
			#10
			if(C == 1 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b & %b = %b, Flags[4:0]: %b", A, B, C, Flags[4:0]);
		
			total=total+1;
			A = 16'hffff; B = 16'h0000;
			#10
			if(C == 0 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b & %b = %b, Flags[4:0]: %b", A, B, C, Flags[4:0]);
			
			//OR
			$display("\tOR:");
			Opcode = 8'b00000010;
			total=total+1;
			A = 16'hf0f0; B = 16'h0f0f;
			#10
			if(C == 16'hffff && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b | %b = %b, Flags[4:0]: %b", A, B, C, Flags[4:0]);
		
			total=total+1;
			A = 16'hffff; B = 16'h0000;
			#10
			if(C == 16'hffff && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b | %b = %b, Flags[4:0]: %b", A, B, C, Flags[4:0]);
			
			//XOR
			$display("\tXOR:");
			Opcode = 8'b00000011;
			total=total+1;
			A = 16'hffff; B = 16'hffff;
			#10
			if(C == 0 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b ^ %b = %b, Flags[4:0]: %b", A, B, C, Flags[4:0]);
		
			total=total+1;
			A = 16'hffff; B = 16'h0000;
			#10
			if(C == 16'hffff && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b ^ %b = %b, Flags[4:0]: %b", A, B, C, Flags[4:0]);
			
			//NOT
			$display("\tNOT:");
			Opcode = 8'b00001111;
			total=total+1;
			A = 16'h0f0f; B = 16'hxxxx;
			#10
			if(C == 16'hf0f0 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t!%b = %b, Flags[4:0]: %b", A, C, Flags[4:0]);
		
			total=total+1;
			A = 16'hffff; B = 16'hxxxx;
			#10
			if(C == 0 && Flags[4:0] == 5'b00000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t!%b = %b, Flags[4:0]: %b", A, C, Flags[4:0]);
			end
			
		

			//LSH
			begin
			Opcode = 8'b10000100;
			
			$display("Shift Operations ----------------------------");
			$display("\tLSH:");
			
			total=total+1;
			A = 16'b0000000000000000;
			#10
			if(C == 0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d << 1 = %0d, Flags[4:0]: %b", $signed(A), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'b1000000000000000;
			#10
			if(C == 0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d << 1 = %0d, Flags[4:0]: %b", $signed(A), $signed(C), Flags[4:0]);
			
			total=total+1;
			A = 16'b1000000000000001;
			#10
			if(C == 2) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d << 1 = %0d, Flags[4:0]: %b", $signed(A), $signed(C), Flags[4:0]);
			end

			//LSHI			
			begin
			Opcode = 8'b10000000;
			
			$display("\tLSHI:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'h0002;
			#10
			if(C == 0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d << %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			total=total+1;
			A = 16'b1000000000000001; B = 16'h0003;
			#10
			if(C == 8) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d << %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			end
			
			//RSHI
			begin
			Opcode = 8'b10000101;
			
			$display("\tRSHI:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'h0002;
			#10
			if(C == 0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d >> %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			total=total+1;
			A = 16'b0000000000001111; B = 16'h0003;
			#10
			if(C == 1) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b >> %0d = %b, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			end
			
			//RSH
			begin
			Opcode = 8'b01001111;
			
			$display("\tRSH:");
			
			total=total+1;
			A = 16'b0000000000000000;
			#10
			if(C == 0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d >> 1 = %0d, Flags[4:0]: %b", $signed(A), $signed(C), Flags[4:0]);
		
			total=total+1;
			A = 16'b0000000000000010;
			#10
			if(C == 1) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d >> 1 = %0d, Flags[4:0]: %b", $signed(A), $signed(C), Flags[4:0]);
			
			total=total+1;
			A = 16'b0000000000000001;
			#10
			if(C == 0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d >> 1 = %0d, Flags[4:0]: %b", $signed(A), $signed(C), Flags[4:0]);	

			total=total+1;
			A = 16'b0000000010000000;
			#10
			if(C == 16'b0000000001000000) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d >> 1 = %0d, Flags[4:0]: %b", $signed(A), $signed(C), Flags[4:0]);	
			end
			
			//ALSH			
			begin
			Opcode = 8'b10000111;
			
			$display("\tALSH:");
			
			total=total+1;
			A = 16'b0000000000000000; B = 16'h0002;
			#10
			if(C == 0) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d <<< %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			total=total+1;
			A = 16'b1000000000000001; B = 16'h0003;
			#10
			if(C == 8) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d <<< %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			end
			
			//ARSH
			begin
			Opcode = 8'b10001xxx;
			
			$display("\tARSH:");
			
			total=total+1;
			A = 16'b0000000001000000; B = 16'h0006;
			#10
			if(C == 1) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%0d >>> %0d = %0d, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			
			total=total+1;
			A = 16'b1000000000001111; B = 16'h0003;
			#10
			if(C == 16'b1111000000000001) begin passed=passed+1; $write("\t\tPASSED:"); end
			else $write("\t\tFAILED:");
			$display("\t%b >>> %0d = %b, Flags[4:0]: %b", $signed(A), $signed(B), $signed(C), Flags[4:0]);
			end
		//Results
		$display("\nRESULTS: %0d/%0d passed", passed, total);
		
	end
      
endmodule

