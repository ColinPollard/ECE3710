module encoder_test(input clk,input switch,input en1a, input en1b, input en2a, input en2b, output [6:0] seg7);


wire [7:0] bcd, slowclock;


clk_divider(
.clk_in(clk),
.rst(),
.clk_out(slowclock)
);

encoder encoder(
	.clk(clk),
	.in1A(en1a),
	.in1B(en1b),
	.in2A(en2a),
	.in2B(en2b),
	.enval(bcd),
	.en_choose(switch)
	);
//quad(
//.clk(slowclock),
//.quadA(en1a),
//.quadB(en1b),
//.count(bcd)
//);
	
	
bcd_to_sev_seg sevenseg(
	.bcd(bcd),
	.seven_seg(seg7)
	);


endmodule