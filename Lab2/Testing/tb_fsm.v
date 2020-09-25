`timescale 1ps / 1ps

module tb_fsm();

//inputs are reg
reg rst, clk, writeEnable;
reg  [15:0] writeValue;
reg [3:0] writeSelect, selectA, selectB;
//outputs are wires
wire [15:0] outA, outB;

regfile reg_1(.readA(outA), .readB(outB), .selectA(4'b0001), .selectB(4'b0001), .writeValue(16'b0000000000000011), .writeSelect(4'b0001), .writeEnable(1'b1), .clock(clk), .reset(rst));

always #5 clk = ~clk;
// give variations
initial begin
//Initialize inputs
clk = 0;
rst = 0; #2;
rst = 1; #5;
rst = 0; #5;
end
endmodule