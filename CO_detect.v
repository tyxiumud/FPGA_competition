`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/20 10:46:54
// Design Name: 
// Module Name: CO_detect
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module CO_detect(
	input 			clk_50M 		,
	input 			s_rst_n 		,
	input 			qiti_en_DO 		,
	output 			qiti_en_voice 	
    );
reg [2:0] qiti_delay;
always @ (posedge clk_50M or negedge s_rst_n)
begin
if(!s_rst_n)
	begin
		qiti_delay <= 'd0;
	end
else 
	begin
		qiti_delay <= {qiti_delay[1:0],qiti_en_DO};
	end
end 
//检测上升沿下降沿
wire nege_qiti;
wire pose_qiti;
assign pose_qiti = (~qiti_delay[2])&&qiti_delay[1];
assign nege_qiti = qiti_delay[2]&&(!qiti_delay[1]);

assign qiti_en_voice = nege_qiti;

endmodule
