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
	output reg [9:0] addressA, addressB;
	
	// 0 Selects output A, 1 Selects output B.
	output reg displaySelect;

	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[4:0] S0 = 5'h00, S1 = 5'h01, S2 = 5'h02, S3 = 5'h03, S4 = 5'h04, S5 = 5'h05;
						
	//Update state
	always @(posedge clk)
	begin
		if(rst) y <= S0;
		else if(y == S5)
			y <= y;
		else begin
			y <= y + 1;
		end
	end

	//Update output
	// Expected output is: 1, 2, 3, 4, 5, 0.
	always @(y)
	begin
		case(y)
			S0: begin // Read from address 0 (expect 1) on A
					
				weA = 1'b0;
				weB = 1'b0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				addressB = 10'd0;
				
				// Set the address to read from
				addressA = 10'd0;
				
				// Set seg7 output to first three bits of result
				displaySelect = 1'b0;
			end
			S1: begin // Read from address 1 (expect 2) on B
					
				weA = 1'b0;
				weB = 1'b0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				addressA = 8'b0;
				
				// Set the address to read from
				addressB = 10'd1;
				
				// Set seg7 output to B
				displaySelect = 1'b1;
			end
			S2: begin // Write to address 0 on A, read from address 2 on B
			
				weB = 1'b0;
				dataInB = 16'd0;
			
				// Enable writing on A
				weA = 1'b1;
				
				// Write value is 4
				dataInA = 16'd4;
				
				// Write address is 0
				addressA = 10'd0;
				
				// Read Address is 3
				addressB = 10'd2;
				
				// Get output
				displaySelect = 1'b1;
				
			end
			S3: begin // Read from address 0 on A, write to address 513 on B
			
				weA = 1'b0;
				dataInA = 16'b0;
				
				// Enable Writing on B
				weB = 1'b1;
				
				// Write value is 5
				dataInB = 16'd5;
				
				// Write address of B is 513
				addressB = 10'd513;
				
				// Read address on A is 0
				addressA = 10'd0;
				
				// Get Output
				displaySelect = 1'b0;

			end
			S4: begin // Read from address 513 on A, reset value at address 0 to 1 on B.
			
				weA = 1'b0;
				weB = 1'b1;
				addressA = 10'd513;
				addressB = 10'd0;
				dataInA = 16'bx;
				dataInB = 16'd1;
				displaySelect = 1'b0;

			end
			S5: begin // Reset value at address 513 to 0 on A. Read from 5 on B.
			
				weA = 1'b1;
				weB = 1'b0;
				addressA = 10'd513;
				addressB = 10'd5;
				dataInA = 16'd0;
				dataInB = 16'dx;
				displaySelect = 1'b1;

			end
			
			default: begin // Do nothing
				weA = 1'b0;
				weB = 1'b0;
				addressA = 10'd0;
				addressB = 10'd0;
				dataInA = 16'd0;
				dataInB = 16'd0;
				displaySelect = 1'b0;
			end
		endcase
	end	

endmodule