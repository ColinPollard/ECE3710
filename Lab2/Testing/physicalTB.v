

module physicalTB(clk, seg7, fsmReset);

input clk, fsmReset;
output[6:0] seg7;

wire reset, write_enable, reg_reset, reg_imm;
wire[3:0] regA, regB, write_select;
wire[7:0] op;
wire[15:0] imm_val, wbValue;

// Create an FSM
fibonacci_fsm FSM(
	.clk(clk), 
	.rst(fsmReset), 
	.write_enable(write_enable), 
	.write_select(write_select), 
	.regA(regA), 
	.regB(regB), 
	.op(op), 
	.reg_imm(reg_imm), 
	.reg_reset(reset),
	.imm_val(imm_val)
);

// Create a datapath instance
regfile_alu_datapath datapath(
	.clk(clk), 
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

// Seven Segment Converter
bcd_to_sev_seg segConverter(
	.bcd(wbValue[3:0]),
	.seven_seg(seg7)
);

endmodule