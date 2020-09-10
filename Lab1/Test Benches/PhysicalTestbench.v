// Authors: Ian Lavin, Colin Pollard
// Date: 9/10/2020
// Test bench for testing the ALU on a physical board.

module PhysicalTestbench(Opcode, seg7, flags);

	// Inputs
	input [7:0] Opcode;
	// Outputs
	output [0:6] seg7;
	output [4:0] flags;
	
	// Hard Coded Values
	reg [15:0] A;
	reg [15:0] B;
	
	// Internal output
	wire [15:0] C;
	
	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.A(16'b0000000000000011), 
		.B(16'b0000000000000011), 
		.C(C), 
		.Opcode(Opcode), 
		.Flags(flags)
	);
	
	// Convert the ALU output to seven segment output.
	bcd_to_sev_seg display (
	.bcd(C),
	.seven_seg(seg7));
      
endmodule

