// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file describes a basic program counter.

module Basic_PC(clk, address, enable);
input clk,enable;
output reg [9:0] address;

// Set the address to point to 0 initially.
initial address = 10'd0;

always @(posedge clk)
begin

	if (enable == 1'b1)
	begin
		address = address + 1'b1;
	end
	
end

endmodule