module transmit_encoder(incomingval,clock,outgoingval, write_en);
input [15:0] incomingval;
input clock, write_en;

output reg [7:0] outgoingval;


always @(posedge clock)
	begin
	if(write_en)
		outgoingval <= incomingval[7:0];
	else
		outgoingval <= outgoingval;
	end

endmodule