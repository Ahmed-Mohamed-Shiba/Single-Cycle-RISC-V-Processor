module PC(
input clk,arst,load,PCSrc,
input [31:0]ImmExt,
output reg [31:0]PC
);

reg [31:0]PCnext;

always @(posedge clk or negedge arst)
begin
	if(~arst)	
		PC <= 32'b0;
	else if (load)
		PC <= PCnext;
	else 
		PC <= PC;
end

always @(*)
begin
	if(PCSrc)
		PCnext = PC + ImmExt;
	else 
		PCnext = PC + 3'b100;

end
endmodule
