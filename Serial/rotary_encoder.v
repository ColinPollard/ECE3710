module encoder(clk, inA, inB, count);
input clk, inA, inB;
output [7:0] count;

reg [2:0] inA_delayed, inB_delayed;
always @(posedge clk) inA_delayed <= {inA_delayed[1:0], inA};
always @(posedge clk) inB_delayed <= {inB_delayed[1:0], inB};

wire count_enable = inA_delayed[1] ^ inA_delayed[2] ^ inB_delayed[1] ^ inB_delayed[2];
wire count_direction = inA_delayed[1] ^ inB_delayed[2];

reg [7:0] count;
always @(posedge clk)
begin
  if(count_enable)
  begin
    if(count_direction) count<=count+1; else count<=count-1;
  end
end

endmodule