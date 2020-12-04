module transmitter_test(input clk, input button, input [7:0]i_Tx_Byte, output serial);

wire buttonout;

buttonlimiter(
.buttonin(button),
.clk(clk),
.buttonout(buttonout)
);


uart_tx(
.i_Clock(clk),
.i_Tx_DV(button),
.i_Tx_Byte(i_Tx_Byte),
.o_Tx_Active(),
.o_Tx_Serial(serial),
.o_Tx_Done()
);


endmodule