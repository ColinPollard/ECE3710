module buttonand(input button1, input button2, input clk, output reg buttonand);

always @(posedge clk) begin

	if (button1 == 0 && button2 == 0) begin
		buttonand = 1;
	end
	
	else begin
		buttonand = 0;
	end 
	
end
endmodule