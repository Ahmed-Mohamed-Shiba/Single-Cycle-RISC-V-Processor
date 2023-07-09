module insMEM(
input [29:0] addr,
output [31:0]Instr
);

reg [31:0] mem[63:0];
initial 
begin

	$readmemh("program.txt",mem);

end
assign Instr = mem[addr];
endmodule
