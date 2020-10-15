// Authors: Colin Pollard, Ian Lavin, McKay Mower
// Date: 10/15/2020
// Test bench for R type functionality.

module R_Type_TB(clk, rst, seg7);
input clk;

// 1Hz clock
wire slowClock;

// Create a clock divider for slow signal
clk_divider divider(
.clk_in(clk), 
.rst(1'b0), 
.clk_out(slowClock)
);

// Current address of the program counter
wire [9:0] currentAddress;
// Create a basic program counter
Basic_PC pc(.clk(slowClock), 
.address(currentAddress));

// Create a datapath instance
regfile_alu_datapath datapath(
	.clk(slowClock), 
	.write_enable(write_enable), 
	.write_select(write_select), 
	.external_write_value(16'b0), 
	.external_write_enable(1'b0), 
	.regA(regA), 
	.regB(regB), 
	.op(op), 
	.reg_imm(reg_imm), 
	.immediate_value(imm_val), 
	.reg_reset(reset), 
	.wbValue(wbValue)
);


// Store the current instruction on the A bus, values on the B bus
wire [15:0] currentInstruction;
// Create a memory module
DualBRAM memoryModule(
.data_a(16'd0),
.data_b(16'd0),
.addr_a(currentAddress),
.addr_b(10'd0),
.we_a(1'b0),
.we_b(1'b0),
.clk_a(clk),
.clk_b(clk),
.q_a(currentInstruction),
.q_b()
);

// Seven Segment Converter
bcd_to_sev_seg segConverter(
	.bcd(wbValue[3:0]),
	.seven_seg(seg7)
);

endmodule