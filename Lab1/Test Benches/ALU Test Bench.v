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
			
		//Results
		$display("\nRESULTS: %0d/%0d passed", passed, total);
		
		
		//Random simulation
		for( i = 0; i< 10; i = i+ 1)
		begin
			#10
			A = $random % 16;
			B = $random % 16;
			//#5
			//$display("A: %0d, B: %0d, C: %0d, Flags[4:0]: %b, time:%0d", A, B, C, Flags[4:0], $time );
		end
		//$finish(2);
		
		// Add stimulus here

	end
      
endmodule

