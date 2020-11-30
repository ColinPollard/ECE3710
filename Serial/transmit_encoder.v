module transmit_encoder(incomingval,clock,outgoingval);
input [15:0] incomingval;
input clock;

output reg [7:0] outgoingval;


always @(posedge clock)
	begin
	outgoingval = incomingval[7:0];
	end



endmodule