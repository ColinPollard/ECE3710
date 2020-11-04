//Top level module used to test the cpu
//This module is the same as the cpu_datapath but it
//does not use the seven seg display

module CPU_test_datapath(slowClock, rst, wbValue);
input slowClock;
input rst;

output [15:0] wbValue;
// 1Hz clock
wire enablewire,LScntl,alu_mux_cntl,we, branch_select, reg_rst, PC_rst;
wire [3:0] regA, regB;
wire [15:0] Din;
wire [15:0] currentInstruction,outgoinginstruction;

// Current address of the program counter
wire [9:0] currentAddress,addressinput,wbaddress;

// Set the address to point to 0 initially.

wire write_enable, r_or_i,IREnable;
wire [4:0] flagModuleOut;
wire [7:0] op;
wire [15:0] imm_val;


// Create a basic program counter
PC pc(
	.clk(slowClock), 
	.address(currentAddress),
	.prev_addr(currentAddress),
	.disp(imm_val),
	.branch_select(branch_select),
	.enable(enablewire),
	.rst(PC_rst)
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
	.reg_reset(reg_rst), 
	.wbValue(wbValue),
	.busA(Din),
	.ALUB(wbaddress),
	.flagModuleOut(flagModuleOut)
);


// Store the current instruction on the A bus, values on the B bus

// Create a memory module
DualBRAM memoryModule(
.data_a(Din),
.data_b(16'd0),
.addr_a(addressinput),
.addr_b(10'd0),
.we_a(we),
.we_b(1'b0),
.clk_a(slowClock),
.clk_b(slowClock),
.q_a(currentInstruction),
.q_b()
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
.irenable(IREnable),
.PC_mux(branch_select),
.reg_rst(reg_rst),
.PC_rst(PC_rst)
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