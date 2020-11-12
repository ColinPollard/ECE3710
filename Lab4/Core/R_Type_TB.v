// Authors: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020
// Test bench for R type functionality.

module CPU_datapath(clk, rst, seg7);
input clk;
input rst;

output [6:0] seg7;
// 1Hz clock
wire slowClock,enablewire,LScntl,alu_mux_cntl,we;
wire [3:0] regA, regB;
wire [15:0] Din;

// Create a clock divider for slow signal
clk_divider divider(
.clk_in(clk), 
.rst(1'b0), 
.clk_out(slowClock)
);

// Current address of the program counter
wire [9:0] currentAddress,addressinput,wbaddress;

// Set the address to point to 0 initially.

wire write_enable, r_or_i,IREnable;
wire [4:0] flagModuleOut;
wire [7:0] op;
wire [15:0] imm_val;
wire [15:0] wbValue;

// Create a basic program counter
PC pc(
	.clk(slowClock), 
	.address(currentAddress),
	.prev_addr(currentAddress),
	.disp(displacement),
	.branch_select(imm_val),
	.enable(enablewire)
);

// Create a datapath instance
regfile_alu_datapath datapath(
	.clk(slowClock), 
	.write_enable(write_enable), 
	.write_select(regA), 
	.external_write_value(currentInstruction), 
	.external_write_enable(alu_mux_cntl), 
	.regA(regA), 
	.regB(regB), 
	.op(op), 
	.reg_imm(r_or_i), 
	.immediate_value(imm_val), 
	.reg_reset(1'b0), 
	.wbValue(wbValue),
	.busA(Din),
	.ALUB(wbaddress),
	.flagModuleOut(flagModuleOut)
);


// Store the current instruction on the A bus, values on the B bus
wire [15:0] currentInstruction,outgoinginstruction;
// Create a memory module
DualBRAM memoryModule(
.data_a(Din),
.data_b(16'd0),
.addr_a(addressinput),
.addr_b(10'd0),
.we_a(we),
.we_b(1'b0),
.clk_a(clk),
.clk_b(clk),
.q_a(currentInstruction),
.q_b()
);

// Seven Segment Converter
bcd_to_sev_seg segConverter(
	.bcd(wbValue),
	.seven_seg(seg7)
);


CPU_FSM FSM(
.clk(slowClock),
.rst(rst),
.PC_enable(enablewire),
.R_enable(write_enable),
.LScntl(LScntl),
.ALU_Mux_cntl(alu_mux_cntl),
.instruction(currentInstruction),
.WE(we),
.flagModuleOut(flagModuleOut),
.irenable(IREnable)
);

Instruction_Decoder decoder(
.instruction(outgoinginstruction),
.op(op),
.rDest(regA),
.rSrc(regB),
.immediate(imm_val),
.r_or_i(r_or_i)
);

mux2to1 LSmux(
.A(wbaddress),
.B(currentAddress),
.ctrl(LScntl),
.out(addressinput)
);

IR_Register irRegister(
.incomingdata(currentInstruction),
.outgoingdata(outgoinginstruction),
.IREnable(IREnable),
.clk(slowClock)
);

endmodule