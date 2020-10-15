// Author: Colin Pollard, Ian Lavin
// Date: 10/15/2020
// This file describes a basic program counter.

module Basic_PC(clk, address);
input clk;
output reg [9:0] address;

// Set the address to point to 0 initially.
initial address = 10'd0;

always @(posedge clk)
begin

	address = address + 1'b1;

end

endmodule