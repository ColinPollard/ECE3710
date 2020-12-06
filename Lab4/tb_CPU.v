`timescale 1ps / 1ps

module tb_CPU();

	// inputs - all registers
	reg rst, clk,  en1, en2, en3, en4, button1, button2;//clk2;
	reg [4:0] switchesL, switchesR;
	// outputs - wires
	wire serial;
	wire [6:0] display1,display2;
	CPU_datapath uut3(clk, rst, en1, en2, en3, en4, serial,button1,button2,display1,display2,switchesL,switchesR);
	
	//always #5 clk2 = ~clk2;
	always #5 clk = ~clk;
//	always@(posedge clk) begin 
//		if(enable)
//			$display("Output: %d", out);
//	end
	initial begin
		//Initialize inputs
		clk = 1;
		button1 = 1;
		button2 = 1;
		#2;
		button1 = 0;
		button2 = 0; #10;
		button1 = 1;
		button2 = 1; #5;		
	end
endmodule