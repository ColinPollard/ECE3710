module Flags(flagsIn, flagsOut, clk);
output reg[4:0] flagsOut;
input[4:0] flagsIn;
input clk;

always @( posedge clk )
	begin
		flagsOut <= flagsIn;
	end

endmodule