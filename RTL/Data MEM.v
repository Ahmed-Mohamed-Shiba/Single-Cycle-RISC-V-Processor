module dataMEM(
input [29:0] addr,WD,
input WE,clk,
output [31:0]RD
);

reg [31:0] mem[63:0];
always @(posedge clk)
begin
	if(WE)
		mem[addr]<= WD;
end
assign RD = mem[addr];
endmodule
