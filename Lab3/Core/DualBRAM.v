module DualBRAM(AddressA, DataInA, DataOutA, clkA, enableA, writeEnableA, AddressB, DataInB, DataOutB, clkB, enableB, writeEnableB);
input [9:0] AddressA, AddressB;
input [15:0] DataInA, DataInB;
input clkA, clkB, enableA, enableB, writeEnableA, writeEnableB;

output [15:0] DataOutA, DataOutB;


endmodule