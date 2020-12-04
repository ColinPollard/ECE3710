module buttonlimiter(input buttonin, input clk,  output reg buttonout);

	reg buttonmem = 0;

always @(posedge clk) begin
	if (buttonmem == 0 && buttonin == 1) begin
	
		if (~buttonin == 1) begin
			buttonout = 1;
			buttonmem = 1;
			end
	end
	
	else if (buttonmem == 1 && buttonin == 1) begin
	buttonout <= 0;
	end
	
	
	else if (buttonmem == 1 && buttonin == 0) begin
	
	
	buttonmem <= 0;
	
	end
	
	
end
	
endmodule