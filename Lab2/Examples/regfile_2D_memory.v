// Given below is a 2D-memory array implementation 
// For simplicity, I'm designing a 4-bitX4  memory
module regfile_2D_memory(ALUBus, r0,r1,r2,r3, regEnable, clk, reset);
	input clk, reset;
	input [3:0] ALUBus;
	input [3:0] regEnable;
	// 4 instances (r0 to r3) of 4-bit registers
	output [3:0] r0, r1, r2, r3; 
	reg [3:0] r [0:7]; // 2-dimensional memory

        // The syntax for the above 2D-array is:
        // reg [DATA_WIDTH - 1: 0] r [0: NUM_WORDS-1]

   
	/********
	Unfortunately, verilog does not allow  the following
	declaration where the 2D memory cannot be  declared as 
	an IO port
	// output reg [3:0] r [0:3];
	*********/
	genvar i;
	
	generate
	for(i=0; i<=3;i=i+1) 
	begin:regfile
		always @(posedge clk)
		begin
			if (reset == 1'b1)
				r[i]<= 4'd0;
			else
				if(regEnable[i]==1'b1)
				r[i] <= ALUBus;
				//else
				//r[i] <= r[i];
		end
	end
	endgenerate
	// assign outputs explicitly
	assign r0 = r[0];
	assign r1 = r[1];
	assign r2 = r[2];
	assign r3 = r[3];
endmodule
