module REG_FILE(
input [4:0] readadd1,readadd2,writeadd,
input [31:0] write_data,
input clk,Wen,arst,
output reg [31:0] read_data1,read_data2
);
integer i;
reg [31:0] reg_file[31:0];
wire [31:0] wire1,wire2;

always@(posedge clk or negedge arst)
begin
if(~arst)
begin
	for(i=0;i<32;i=i+1)
	begin
		reg_file[i] <= 0 ;
	end
end
else if(Wen)
	reg_file[writeadd] <= write_data;


end
always@(*)
begin
 	read_data1 = reg_file[readadd1];
	read_data2 = reg_file[readadd2];
end
assign wire1 = read_data1;
assign wire2 = read_data2;
endmodule
