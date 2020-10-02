module physicalMemoryTB(clk, seg7, reset);

input clk, reset;
output [6:0] seg7;

// 1Hz clock for fsm.
wire slowClock;

// Create a clock divider for slow signal
clk_divider divider(
.clk_in(clk), 
.rst(1'b0), 
.clk_out(slowClock)
);

// Create a bus to hold the output value from the FSM.
wire[3:0] display;

// Create a seven segment decoder.
bcd_to_sev_seg decoder(
.bcd(display),
.seven_seg(seg7)
);

wire [15:0] dataInA, dataInB, dataOutA, dataOutB;
wire [9:0] addressA, addressB;
wire weA, weB, displaySelect;

// Create an FSM
memoryFSM fsm(
.clk(slowClock), 
.rst(~reset), 
.displaySelect(displaySelect), 
.dataInA(dataInA), 
.dataInB(dataInB), 
.addressA(addressA), 
.addressB(addressB), 
.weA(weA), 
.weB(weB), 
.dataOutA(dataOutA), 
.dataOutB(dataOutB)
);

// MUX for selecting display output
mux2to1_4bit DisplayMUX(
.A(dataOutA), 
.B(dataOutB), 
.ctrl(displaySelect), 
.out(display)
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