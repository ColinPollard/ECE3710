// Author: Colin Pollard, Ian Lavin, Luke Majors, McKay Mower
// Date: 9/29/2020
// This module represents a true dual port dual clock RAM with a data width of 16 and an address width of 10.

module DualBRAM
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=10)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk_a, clk_b,
	
	// TODO: Check to see if this is the best means of doing this.
	// In order to reset memory to known values, the ram variable must be accessible to readmemb.
	// We created a pin that will call that function when true - initializeMemory.
	input initializeMemory,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	// Check for initialization
	always @ (posedge initializeMemory)
	begin
		if (initializeMemory)
		begin
			$readmemb("../Test/ZeroMemory.mif", ram);
		end
	end

	always @ (posedge clk_a)
	begin
		// Port A 
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end

	always @ (posedge clk_b)
	begin
		// Port B 
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule
