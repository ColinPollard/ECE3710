// Code courtesy of: https://project4sciencefair.wordpress.com/2012/10/24/4-to-16-decoder-verilog-code/#:~:text=Decoder%20is%20a%20digital%20circuit,verilog%20code%20arr%20given%20bellow.
// Four bit to 16 bit decoder used for assigning register enable pins.
module decoder(in, enable, d);
input  [3:0] in;
input enable;
output [15:0] d;

assign d[0]=  (~in[0]) & (~in[1]) &(~in[2]) & (~in[3]) & (enable);
assign d[1]=  (~in[0]) & (~in[1]) &(~in[2]) & (in[3]) & (enable);
assign d[2]=  (~in[0]) & (~in[1]) &(in[2]) & (~in[3]) & (enable);
assign d[3]=  (~in[0]) & (~in[1]) &(in[2])  & (in[3]) & (enable);
assign d[4]=  (~in[0]) & (in[1]) &(~in[2]) & (~in[3]) & (enable);
assign d[5]=  (~in[0]) & (in[1]) &(~in[2])  & (in[3]) & (enable);
assign d[6]=  (~in[0]) & (in[1]) &(in[2])  & (~in[3]) & (enable);
assign d[7]=  (~in[0]) & (in[1]) &(in[2])  & (in[3]) & (enable);

assign d[8]=  (in[0]) & (~in[1]) &(~in[2]) & (~in[3]) & (enable);
assign d[9]=  (in[0]) & (~in[1]) &(~in[2]) & (in[3]) & (enable);
assign d[10]= (in[0]) & (~in[1]) &(in[2]) & (~in[3]) & (enable);
assign d[11]= (in[0]) & (~in[1]) &(in[2])  & (in[3]) & (enable);
assign d[12]= (in[0]) & (in[1]) &(~in[2]) & (~in[3]) & (enable);
assign d[13]= (in[0]) & (in[1]) &(~in[2])  & (in[3]) & (enable);
assign d[14]= (in[0]) & (in[1]) &(in[2])  & (~in[3]) & (enable);
assign d[15]= (in[0]) & (in[1]) &(in[2])  & (in[3]) & (enable);

endmodule