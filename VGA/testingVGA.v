module VGA_test(clk,reset,vga_clock,vga_blank, vga_vs, vga_hs,r,g,b);

input clk, reset;
output vga_clock, vga_blank,vga_vs,vga_hs;
output [7:0] r,g,b;

wire [9:0] hcount, vcount;


vga_control cntl(
.clk(clk),
.rst(~reset),
.vga_blank_n(vga_blank),
.vga_clk(vga_clock),
.hcount(hcount),
.vcount(vcount)
);

bitgen gen(
.bright(vga_blank),
.hcount(hcount),
.vcount(vcount),
.rgb({r,g,b})
);

endmodule