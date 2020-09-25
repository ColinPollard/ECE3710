// Code courtesy of: https://project4sciencefair.wordpress.com/2012/10/24/4-to-16-decoder-verilog-code/#:~:text=Decoder%20is%20a%20digital%20circuit,verilog%20code%20arr%20given%20bellow.
// Four bit to 16 bit decoder used for assigning register enable pins.
module decoder(in, enable, d);
input  [3:0] in;
input enable;
output reg [15:0] d;

always@(in, enable) begin
	if(enable) begin
		case(in)
			4'h0: d = 16'h0001;
			4'h1: d = 16'h0002;
			4'h2: d = 16'h0004;
			4'h3: d = 16'h0008;
			4'h4: d = 16'h0010;
			4'h5: d = 16'h0020;
			4'h6: d = 16'h0040;
			4'h7: d = 16'h0080;
			4'h8: d = 16'h0100;
			4'h9: d = 16'h0200;
			4'ha: d = 16'h0400;
			4'hb: d = 16'h0800;
			4'hc: d = 16'h1001;
			4'hd: d = 16'h2000;
			4'he: d = 16'h4000;
			4'hf: d = 16'h8000;
			default: d = 16'h0000;
		endcase
	end
	else d = 16'h0000;
end
endmodule