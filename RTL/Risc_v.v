module Risc_v(
input clk,arst
);

wire [31:0]ALUResult,SrcA,SrcB,RD2,ImmExt,PC,instr,Result,ReadData;
wire ZF,CF,PCSrc,load,RWen,ResultSrc,WE,ALUSrc;
wire [1:0]ImmSrc;
wire [2:0]ALUControl;


assign SrcB = ALUSrc?ImmExt:RD2;
assign Result = ResultSrc?ReadData:ALUResult; 
assign load=1;

ALU alu1(.A(SrcA),.B(SrcB),.OPcode(ALUControl),.CF(CF),.ZF(ZF),.Out(ALUResult));

PC pc1(.clk(clk),.arst(arst),.load(load),.PCSrc(PCSrc),.ImmExt(ImmExt),.PC(PC));

insMEM inst1(.addr(PC[31:2]),.Instr(instr));

REG_FILE reg1(.readadd1(instr[19:15]),.readadd2(instr[24:20]),.writeadd(instr[11:7]),
.write_data(Result),.clk(clk),.Wen(RWen),.arst(arst),
.read_data1(SrcA),.read_data2(RD2));


control_unit cpu1(.instr(instr),.ZFlag(ZF),.SFlag(ALUResult[31]),
.PCSrc(PCSrc),.ResultSrc(ResultSrc),.MEMWrite(WE),.ALUSrc(ALUSrc),.RegWrite(RWen),
.ImmSrc(ImmSrc),
.ALUControl(ALUControl));

dataMEM data1 (.addr(ALUResult[31:2]),.WD(RD2),.WE(WE),.clk(clk),
.RD(ReadData));

sign_extend ext1(.ImmSrc(ImmSrc),.instr(instr[31:7]),.ImmExt(ImmExt));


endmodule 