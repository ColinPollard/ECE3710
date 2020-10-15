// Author: Colin Pollard, Ian Lavin
// Date: 10/15/2020
// This file creates an FSM to control basic R-type instructions.

module R_Type_FSM(clk, rst, dataInA, dataInB, addressA, addressB, weA, weB, dataOutA, dataOutB, write_enable, write_select, regA, regB, op, reg_imm, reg_reset, imm_val);
input clk, rst;

// Which register to write back into
output [3:0] write_select;

// Which registers to read into ALU.
output [3:0] regA, regB;

// op code to alu
output [7:0] op;

// Selects ALU B input. 0=RegisterB, 1=imm_val
output reg_imm;

// Reset all registers in the ALU datapath.
output reg_reset;

// Enable writeback into register.
output write_enable;

// Optional immediate value for ALU B input. Only goes through if reg_imm is HIGH.
output [15:0] imm_val;

output dataInA, dataInB;


endmodule