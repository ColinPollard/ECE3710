// Authors: Colin Pollard, Ian Lavin, McKay Mower, Luke Majors
// Date: 10/15/2020

module CPU_datapath(clk, rst, en1a, en1b, en2a, en2b, serial,button1,button2,display1,display2,switchesL,switchesR);
input clk, button1,button2;
input rst;
input en1a, en1b, en2a, en2b;

input [4:0] switchesL, switchesR;

output serial;
// 1Hz clock
wire slowClock,enablewire,LScntl,alu_mux_cntl,we, branch_select,en_mux, ensel,trans_en, done, trans_reg_en,transmitting,reg_rst,en_select,encoder1_rst,encoder2_rst,switch_sel,switch_mux;
wire [3:0] regA, regB;
wire [15:0] Din,enval;
wire [15:0] currentInstruction,outgoinginstruction;

output [6:0] display1,display2;

// Create a clock divider for slow signal
clk_divider divider(
.clk_in(clk), 
.rst(1'b0), 
.clk_out(slowClock)
);

// Current address of the program counter
wire [9:0] currentAddress,addressinput,wbaddress;

// Set the address to point to 0 initially.

wire write_enable, r_or_i,IREnable,PC_rst,buttonand;
wire [4:0] flagModuleOut;
wire [7:0] op,transmitval;
wire [15:0] imm_val,encoderval;
wire [15:0] wbValue;

// Create a basic program counter
PC pc(
	.clk(clk), 
	.address(currentAddress),
	.prev_addr(currentAddress),
	.disp(imm_val),
	.branch_select(branch_select),
	.enable(enablewire),
	.rst(PC_rst)
);

// Create a datapath instance
regfile_alu_datapath datapath(
	.clk(clk), 
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
	.flagModuleOut(flagModuleOut),
	.encoder_value(enval),
	.external_encoder_enable(en_mux),
	.p1display(display1),
	.p2display(display2),
	.switchL(switchesL),
	.switchR(switchesR),
	.switch_select(switch_sel),
	.switch_mux(switch_mux)
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
.clk_a(clk),
.clk_b(clk),
.q_a(currentInstruction),
.q_b()
);

CPU_FSM FSM(
.clk(clk),
//this changes based on button input
.rst(~rst),

//
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
.PC_rst(PC_rst),
.transmit_enable(trans_en),
.en_select(en_select), 
.en_mux(en_mux),
.transmitting(transmitting),
.transmit_reg_en(trans_reg_en),
.en1rst(encoder1_rst),
.en2rst(encoder2_rst),
.switch_select(switch_sel),
.switch_mux(switch_mux)
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
.clk(clk)
);

encoder encodermodule(
	.clk(clk),
	.rst1(encoder1_rst),
	.rst2(encoder2_rst),
	.in1A(en1a),
	.in1B(en1b),
	.in2A(en2a),
	.in2B(en2b),
	.enval(enval),
	.en_choose(en_select)
);

uart_tx transmitter(
.i_Clock(clk),
.i_Tx_DV(trans_en),
.i_Tx_Byte(transmitval),
.o_Tx_Active(transmitting),
.o_Tx_Serial(serial),
.o_Tx_Done(done)
);


transmit_encoder encode(
.write_en(trans_reg_en),
.incomingval(wbaddress),
.clock(clk),
.outgoingval(transmitval)
);

buttonand andgate(
.button1(button1),
.button2(button2),
.clk(clk),
.buttonand(buttonand)
);

endmodule