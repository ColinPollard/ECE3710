// Author: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// This file describes a basic program counter.

module PC(rclk, address, enable, disp, branch_select, prev_addr);
input clk,enable, branch_select;
input [7:0] disp;
input [9:0] prev_addr;
output reg [9:0] address;

always @(posedge clk)
begin
	if (enable == 1'b1)
	begin
		if(branch)
			address <= prev_addr + disp;
		else
			address <= prev_addr + 1'b1;
	end
	
end

endmodule
