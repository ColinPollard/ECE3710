module encoder(clk,rst1, rst2, in1A, in1B, in2A, in2B, enval,en_choose);
input clk, rst1, rst2, in1A, in1B,in2A, in2B,en_choose;
output [15:0] enval;

//This is for rotary encoder 1
reg [2:0] in1A_delayed, in1B_delayed;
always @(posedge clk) in1A_delayed <= {in1A_delayed[1:0], in1A};
always @(posedge clk) in1B_delayed <= {in1B_delayed[1:0], in1B};

wire count_enable1 = in1A_delayed[1] ^ in1A_delayed[2] ^ in1B_delayed[1] ^ in1B_delayed[2];
wire count_direction1 = in1A_delayed[1] ^ in1B_delayed[2];

reg [15:0] count1;
always @(posedge clk)
begin
	if (rst1 == 1)
		count1 <= 0;
		
	else begin

	  if(count_enable1)
	  begin
		 if(count_direction1) count1<=count1+1; else count1<=count1-1;
	  end
	 end
end



//This is for rotary encoder number 2
reg [2:0] in2A_delayed, in2B_delayed;
always @(posedge clk) in2A_delayed <= {in2A_delayed[1:0], in2A};
always @(posedge clk) in2B_delayed <= {in2B_delayed[1:0], in2B};

wire count_enable2 = in2A_delayed[1] ^ in2A_delayed[2] ^ in2B_delayed[1] ^ in2B_delayed[2];
wire count_direction2 = in2A_delayed[1] ^ in2B_delayed[2];

reg [15:0] count2;
always @(posedge clk)
begin
	if (rst2 == 1)
		count2 <= 0;
		
	else begin	
	  if(count_enable2)
	  begin
		 if(count_direction2) count2<=count2+1; else count2<=count2-1;
	  end
	end
end


// mux instantiation

mux2to1 encoderchooser(
	.A(count1), 
	.B(count2), 
	.ctrl(en_choose),
	.out(enval)
);


endmodule