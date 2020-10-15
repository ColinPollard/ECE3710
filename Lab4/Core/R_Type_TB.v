// Authors: Colin Pollard, Ian Lavin, McKay Mower
// Date: 10/15/2020
// Test bench for R type functionality.

module R_Type_TB();



// Create a datapath instance
regfile_alu_datapath datapath(
	.clk(~clk), 
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

// Create a clock divider for slow signal
clk_divider divider(
.clk_in(clk), 
.rst(1'b0), 
.clk_out(slowClock)
);

// Create a memory module
DualBRAM memoryModule(
.data_a(dataInA),
.data_b(dataInB),
.addr_a(addressA),
.addr_b(addressB),
.we_a(weA),
.we_b(weB),
.clk_a(clk),
.clk_b(clk),
.q_a(dataOutA),
.q_b(dataOutB)
);

endmodule