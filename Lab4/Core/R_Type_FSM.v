// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file creates an FSM to control basic R-type instructions.

module R_Type_FSM(clk, rst, PC_enable);
	input clk, rst;
	
	
	// FSM States --------------------------------------------------------------------------------
	
	//Store state
	reg[3:0] y;
	
	//Parameters for the fsm states
	parameter[3:0] S0 = 4'h00, S1 = 4'h01, S2 = 4'h02, S3 = 4'h03, S4 = 4'h04, S5 = 4'h05;
						
	//Update state
	always @(posedge clk)
	begin
		if(rst) y <= S0;
		else if(y == S5)
			y <= y;
		else begin
			y <= y + 1'b1;
		end
	end
	
	
	//Update output
	// Expected output is: 1, 2, 3, 4, 5, 0.
	always @(y)
	begin
		case(y)
			S0: begin // Read from address 0 (expect 1) on A
					
			
			end
			S1: begin // Read from address 1 (expect 2) on B
			
			end
			S2: begin // Write to address 0 on A, read from address 2 on B
			
			
			end
			S3: begin // Read from address 0 on A, write to address 513 on B
			
			

			end
			S4: begin // Read from address 513 on A, reset value at address 0 to 1 on B.
			

			end
			S5: begin // Reset value at address 513 to 0 on A. Read from 5 on B.
			
			

			end
			
			default: begin // Do nothing
				
			end
		endcase
	end
endmodule