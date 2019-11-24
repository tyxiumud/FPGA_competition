`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:58:02 10/22/2019 
// Design Name: 
// Module Name:    zhiwen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module zhiwen_z(
	input chumo,
	input over_all,
	input zhongzhi,
	//input clk,
	//input rst_n,
	
	output reg tx_en
    );
/*reg [25:0]cnt;
always@(posedge clk or negedge rst_n)     //这里需要有1s的延迟 再检测指纹
begin
	if(!rst_n)
	cnt<=1'b0;
	else if(cnt==26'd49_999)
	cnt<=1'b0;
	else cnt<=cnt+1'b1;
end*/
always@(*)
begin
	if(zhongzhi)
		tx_en=1'b1;
	else if(over_all)
		tx_en=1'b0;
	else if(chumo/*&cnt==26'd49_999*/)
		tx_en=1'b1;
	else tx_en=1'b0;
end 
endmodule
