`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:55 10/27/2019 
// Design Name: 
// Module Name:    decomposes 
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
module decomposes_v(
	clk,rst_n,in,data,data1,data2,data3,data4,data5,data6
	   );
		
	input clk;								//系统时钟
	input rst_n;							//系统复位						
	input in;								//总使能
	input [47:0] data;						//输入指令数据
	output reg [7:0] data1;					//指令第一位数据
	output reg [7:0] data2;					//指令第二位数据
	output reg [7:0] data3;					//指令第三位数据
	output reg [7:0] data4;					//指令第四位数据
	output reg [7:0] data5;					//指令第五位数据
	output reg [7:0] data6;					//指令第六位数据
	  
		
always@(posedge clk)
begin
	if(!rst_n)
		begin
		data1 <= 0;
		data2 <= 0;
		data3 <= 0;
		data4 <= 0;
		data5 <= 0;
		data6 <= 0;
		end
	else if(!in)
		begin
		data1 <= 0;
		data2 <= 0;
		data3 <= 0;
		data4 <= 0;
		data5 <= 0;
		data6 <= 0;
		end
	else
		begin
		data1 <= data[47:40];
		data2 <= data[39:32];
		data3 <= data[31:24];
		data4 <= data[23:16];
		data5 <= data[15:8];
		data6 <= data[7:0];
		end
end

endmodule
