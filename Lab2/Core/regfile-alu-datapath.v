// Wrapper for ALU, regfiles, mux, etc.
// Inputs are all of the control signals

//readA, readB, selectA, selectB, writeValue, writeSelect, writeEnable, clock, reset
module regfile_alu_datapath(clk, write_enable, write_select, external_write_value, external_write_enable, regA, regB, op, reg_imm, reg_reset);
input clk, reg_imm, write_enable, reg_reset;
input [15:0] regA, regB, write_select, immediate_value, external_write_value;
input [7:0] op;

wire [15:0] busA, busB, ALUB, wbValue, ALUC;
wire BSelect, external_write_enable;


// BUS B MUX
mux2to1 bMUX(
	.A(ALUB), 
	.B(immediate_value), 
	.ctrl(reg_imm), 
	.out(busB)
);

// Writeback MUX
mux2to1 wbMUX(
	.A(ALUC), 
	.B(external_write_value), 
	.ctrl(external_write_enable), 
	.out(wbValue)
);

// Instantiate the regfile
regfile regfileInstance(
	.readA(busA), 
	.readB(ALUB), 
	.selectA(regA), 
	.selectB(regB), 
	.writeValue(wbValue), 
	.writeSelect(write_select), 
	.writeEnable(write_enable), 
	.clock(clk), 
	.reset(reg_reset)
);

wire [4:0] ALUFlagOut, flagModuleOut;

// ALU Flags Module
Flags flagsModule(
	.flagsIn(flagOut), 
	.flagsOut(flagModuleOut), 
	.clk(clk)
);

// Instantiate the ALU
alu aluInstance (
	.A(busA), 
	.B(busB),
	.cin(flagModuleOut[0]),
	.C(ALUC), 
	.Opcode(op), 
	.Flags(flagOut)
);

endmodule