// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file describes a basic program counter.

module PC(clk, rst, address, enable, disp, branch_select, prev_addr);
input clk,enable, branch_select, rst;
input [7:0] disp;
input [9:0] prev_addr;
output reg [9:0] address = 0;

always @(posedge clk)
begin
	if(rst)
		address <= 0;
	else if (enable == 1'b1)
	begin
		if(branch_select)
			address <= prev_addr + disp;
		else
			address <= prev_addr + 1'b1;
	end
	
end

endmodule
