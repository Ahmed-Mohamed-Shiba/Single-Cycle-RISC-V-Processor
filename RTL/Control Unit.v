
module control_unit(
input [31:0] instr,
input ZFlag,SFlag,
output reg PCSrc,ResultSrc,MEMWrite,ALUSrc,RegWrite,
output reg [1:0] ImmSrc,
output reg [2:0] ALUControl
);

wire [6:0]opcode;
wire [2:0]func3;
reg Branch;
reg [1:0] ALUOp;

assign opcode = instr[6:0];
always@(*)
begin
case(opcode)
7'b000_0011:
begin
	RegWrite=1;
	ImmSrc=2'b00;
	ALUSrc=1;
	MEMWrite=0;
	ResultSrc=1;
	Branch=0;
	ALUOp=2'b00;
end
7'b010_0011:
begin
	RegWrite=0;
	ImmSrc=2'b01;
	ALUSrc=1;
	MEMWrite=1;
	ResultSrc=1'bx;
	Branch=0;
	ALUOp=2'b00;
	end
//	{RegWrite,ImmSrc,ALUSrc,MEMWrite,ResultSrc,Branch,ALUOp} = 9'b0_01_1_1_x_0_00;
7'b011_0011:
begin
	RegWrite=1;
	ImmSrc=2'bxx;
	ALUSrc=0;
	MEMWrite=0;
	ResultSrc=0;
	Branch=0;
	ALUOp=2'b10;
	end
//	{RegWrite,ImmSrc,ALUSrc,MEMWrite,ResultSrc,Branch,ALUOp} = 9'b1_xx_0_0_0_0_10;
7'b001_0011:
begin
	RegWrite=1;
	ImmSrc=2'b00;
	ALUSrc=1;
	MEMWrite=0;
	ResultSrc=0;
	Branch=0;
	ALUOp=2'b10;
	end
//	{RegWrite,ImmSrc,ALUSrc,MEMWrite,ResultSrc,Branch,ALUOp} = 9'b1_00_1_0_0_0_10;
7'b110_0011:
begin
	RegWrite=0;
	ImmSrc=2'b10;
	ALUSrc=0;
	MEMWrite=0;
	ResultSrc=1'bx;
	Branch=1;
	ALUOp=2'b01;
	end
//	{RegWrite,ImmSrc,ALUSrc,MEMWrite,ResultSrc,Branch,ALUOp} = 9'b0_10_0_0_x_1_01;
default:
	begin
	RegWrite=0;
	ImmSrc=2'b00;
	ALUSrc=0;
	MEMWrite=0;
	ResultSrc=0;
	Branch=0;
	ALUOp=2'b00;
	end
endcase
end

assign func3 = instr[14:12];
always@(*)
begin
//ALUControl = 3'b000;
//PCSrc =Branch & ZFlag;
case(ALUOp)
2'b00: begin ALUControl = 3'b000;PCSrc =Branch & ZFlag;end
2'b01:	if (instr[14:12] == 3'b000) begin
		PCSrc = Branch & ZFlag;
		ALUControl = 3'b010;
		end
	else if (instr[14:12] == 3'b001) begin
		PCSrc = Branch & (~ZFlag);
		ALUControl = 3'b010;
		end
	else if (instr[14:12] == 3'b100) begin
		PCSrc = Branch & SFlag;
		ALUControl = 3'b010;
		end
	else  
		begin
		PCSrc = Branch & ZFlag;
		ALUControl = 3'b010;
		end
	
2'b10: begin PCSrc =Branch & ZFlag;
	case(instr[14:12])
	3'b000:
	begin
	if({opcode[5],instr[30]} == 2'b11)
		ALUControl = 3'b010;
	else
		ALUControl = 3'b000;
	end
	3'b001:  ALUControl =3'b001;
	3'b100:  ALUControl =3'b100;
	3'b101:  ALUControl =3'b101;
	3'b110:  ALUControl =3'b110;
	3'b111:  ALUControl =3'b111;
	default: ALUControl =3'b000;
	endcase
	end
default: begin ALUControl = 3'b000;PCSrc = Branch & ZFlag; end


endcase
end
endmodule 