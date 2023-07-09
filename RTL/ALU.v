
module ALU(A,B,OPcode,CF,ZF,Out);
	input[31:0] A,B;
	input [2:0]OPcode;
	output ZF;
	output reg CF;
	output reg[31:0]Out;
always @(*)

begin
case (OPcode)
3'b000: {CF,Out}=A+B;
3'b001: {CF,Out}=A<<B;
3'b011: {CF,Out}=B;
3'b010: {CF,Out}=A-B;
3'b100: {CF,Out}=A^B;
3'b101: {CF,Out}=A>>B;
3'b110: {CF,Out}=A|B;
3'b111: {CF,Out}= A&B;
default: {CF,Out}=32'h0000;
endcase
end

//assign CF = Out[32];
assign ZF = ~|(Out);

endmodule
