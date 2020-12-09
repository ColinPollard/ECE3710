module VGA_test(clk,reset,num,vga_clock,vga_blank, vga_vs, vga_hs,r,g,b);

input clk, reset;
input [3:0] num;
output vga_clock, vga_blank,vga_vs,vga_hs;
output [7:0] r,g,b;

wire [9:0] hcount, vcount;
wire [0:6] p1Score, p2Score;

bcd_to_sev_seg p1(
.bcd(num),
.seven_seg(p1Score)
);

bcd_to_sev_seg p2(
.bcd(num),
.seven_seg(p2Score)
);

vga_control cntl(
.clk(clk),
.rst(~reset),
.vga_blank_n(vga_blank),
.vga_clk(vga_clock),
.hcount(hcount),
.vcount(vcount),
.hsync(vga_hs),
.vsync(vga_vs)
);

bitgen gen(
.bright(vga_blank),
.hcount(hcount),
.vcount(vcount),
.rgb({r,g,b}),
.p1(~p1Score),
.p2(~p2Score)
);

endmodule