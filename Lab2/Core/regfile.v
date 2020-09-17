// REGFILE

// Single register instance.
module Register(in, wEnable, clk, r);
	 input [15:0] in;
	 input clk, wEnable;
	 output reg [15:0] r;
	 
 always @( posedge clk )
	begin			
		if (wEnable)
			begin
				r <= in;
			end
		else
			begin
				r <= r;
			end
	end
endmodule


module regfile(readA, readB, write, regEnable, clock);

// Output ports A and B
output reg [15:0] readA, readB;

// Value to write to register
input[15:0] write;

// Which register to write to
input[3:0] regEnable;

// Clock signal
input clock;

endmodule