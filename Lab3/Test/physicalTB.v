module physicalMemoryTB(clk, seg7);

input clk;
output [6:0] seg7;

// Create a bus to hold the output value from the FSM.
wire[3:0] display;
// Create a seven segment decoder.
bcd_to_sev_seg decoder(
.bcd(display),
.seven_seg(seg7)
);

endmodule