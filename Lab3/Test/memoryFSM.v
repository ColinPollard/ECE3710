// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/1/2020
// This module demonstrates and tests reading and writing to the memory module.

module memoryFSM(clk, rst, displaySelect, dataInA, dataInB, addressA, addressB, weA, weB, dataOutA, dataOutB);
	
	// Clock to fsm, reset state to 0.
	input clk, rst;
	
	// These are the data outputs from the bram, and inputs to the fsm (fetch result).
	input [15:0] dataOutA, dataOutB;
	
	// Write enables, clocks for the bram, and initializememory call.
	output reg weA, weB;
	
	// Data input to bram, output from fsm (write to memory).
	output reg [15:0] dataInA, dataInB;
	
	// Addresses to access/write to.
	output reg [7:0] addressA, addressB;
	
	// 0 Selects output A, 1 Selects output B.
	output reg displaySelect;

	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[4:0] S0 = 5'h00, S1 = 5'h01, S2 = 5'h02, S3 = 5'h03, S4 = 5'h04, S5 = 5'h05, S6 = 5'h06, S7 = 5'h07,
						S8 = 5'h08, S9 = 5'h09, S10 = 5'h0a, S11 = 5'h0b, S12 = 5'h0c, S13 = 5'h0d, S14 = 5'h0e, S15 = 5'h0f,
						S16 = 5'h10;
						
	//Update state
	always @(posedge clk)
	begin
		if(rst) y <= S0;
		else if(y == S16)
			y <= y;
		else begin
			y <= y + 1;
		end
	end

	//Update output
	// Expected output is: 1, 2, 3, 5, 6.
	always @(y)
	begin
		case(y)
			S0: begin // Read from address 0 (expect 1) on A
					
				weA = 1'b0;
				weB = 1'b0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				addressB = 8'd0;
				
				// Set the address to read from
				addressA = 8'd0;
				
				// Set seg7 output to first three bits of result
				displaySelect = 1'b0;
			end
			S1: begin // Read from address 1 (expect 2) on B
					
				weA = 1'b0;
				weB = 1'b0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				addressA = 8'bx;
				
				// Set the address to read from
				addressB = 8'd1;
				
				// Set seg7 output to B
				displaySelect = 1'b1;
			end
			S2: begin // Write to address 0 on A, read from address 3 on B
			
				weB = 1'b0;
				dataInB = 16'd0;
			
				// Enable writing on A
				weA = 1'b1;
				
				// Write value is 5
				dataInA = 16'd5;
				
				// Write address is 0
				addressA = 8'd0;
				
				// Read Address is 3
				addressB = 8'd3;
				
				// Get output
				displaySelect = 1'b1;
				
			end
			S3: begin // Read from address 0 on A, write to address 513 on B
			
				weA = 1'b0;
				dataInA = 16'b0;
				
				// Enable Writing on B
				weB = 1'b1;
				
				// Write value is 1024
				dataInB = 16'd6;
				
				// Write address of B is 513
				addressB = 8'd513;
				
				// Read address on A is 0
				addressA = 0;
				
				// Get Output
				displaySelect = 1'b0;

			end
			S4: begin // Read from address 513 on A, reset value at address 0 to 1 on B.
			
				weA = 1'b0;
				weB = 1'b1;
				addressA = 8'd513;
				addressB = 8'd0;
				dataInA = 16'bx;
				dataInB = 16'd1;
				displaySelect = 1'b0;

			end
			S5: begin // Reset value at address 513 to 0 on A. Read from 0 on B.
			
				weA = 1'b1;
				weB = 1'b0;
				addressA = 8'd513;
				addressB = 8'd0;
				dataInA = 16'd0;
				dataInB = 16'dx;
				displaySelect = 1'b1;

			end
			
			default: begin
				weA = 1'b0;
				weB = 1'b0;
				addressA = 8'd0;
				addressB = 8'd0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				displaySelect = 1'b0;
			end
		endcase
	end	

endmodule