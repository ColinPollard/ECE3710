module encoder_test(input clk,input switch,input en1a, input en1b, input en2a, input en2b, output [7:0] seg7);


wire bcd;


encoder encoder(
	.clk(clk),
	.in1A(en1a),
	.in1B(en1b),
	.in2A(en2a),
	.in2B(en2b),
	.enval(bcd),
	.en_choose(switch)
	);

bcd_to_sev_seg sevenseg(
	.bcd(bcd),
	.seven_seg(seg7)
	);


endmodule