// Wrapper for ALU, regfiles, mux, etc.
// Inputs are all of the control signals

module regfile_alu_datapath(clk, write_enable, write_select, external_write_value, external_write_enable, regA, regB, op, reg_imm, immediate_value, reg_reset, wbValue, busA, ALUB, flagModuleOut,encoder_value,external_encoder_enable,p1display,p2display);

input clk, reg_imm, write_enable, reg_reset, external_write_enable,external_encoder_enable;
input [15:0] immediate_value, external_write_value,encoder_value;
input [3:0] regA, regB, write_select;
input [7:0] op;

output [6:0] p1display,p2display;

output [4:0] flagModuleOut;
// For testing, normally would be a wire.
output[15:0] wbValue, busA, ALUB;

wire [15:0] busB, ALUC,tempwbVal,p1score,p2score;


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
	.out(tempwbVal)
);

//encoder value
mux2to1 encoderMUX(
	.A(tempwbVal), 
	.B(encoder_value), 
	.ctrl(external_encoder_enable), 
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
	.reset(reg_reset),
	.r14(p1score),
	.r15(p2score)
);

wire [4:0] ALUFlagOut;

// ALU Flags Module
Flags flagsModule(
	.flagsIn(ALUFlagOut), 
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
	.Flags(ALUFlagOut)
);

bcd_to_sev_seg seg1(
.bcd(p1score),
.seven_seg(p1display)
);

bcd_to_sev_seg seg2(
.bcd(p2score),
.seven_seg(p2display)
);

endmodule