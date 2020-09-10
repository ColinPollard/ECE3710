`timescale 1ns / 1ps

module alutest;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [7:0] Opcode;

	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;

	integer i;
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

		// Wait 100 ns for global reset to finish

		// One vector-by-vector case simulation
		#10;
	        Opcode = 8'b00000001;
		A = 16'b0000000000000000; B = 16'b0000000000000000;
		#10
		//A = 8'b00001111; B = 8'b00000001;
		$display("A: %d, B: %d, C:%d, Flags[4:0]: %b, time:%d", $signed(A), $signed(B), $signed(C), Flags[4:0], $time);

		//Random simulation
		for( i = 0; i< 10; i = i+ 1)
		begin
			#10
			A = $random % 16;
			B = $random % 16;
			#5
			$display("A: %0d, B: %0d, C: %0d, Flags[4:0]: %b, time:%0d", A, B, C, Flags[4:0], $time );
		end
		//$finish(2);
		
		// Add stimulus here

	end
      
endmodule

