`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:05:07 10/28/2019 
// Design Name: 
// Module Name:    measurement 
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
module measurement(
	//system singnals
	input 				clk_50M 	,
	input 				s_rst_n 	,
	//supersonic wave module singnals
	input 				Echo 		,
	output 	reg 		trig 		,
	//connect with Nixie tube display
	output 	reg [15:0] 	data 	
    );
//////////////////////////////////////////////////////////////////////////////////
//generate cnt_17M_en
//单比特跨时钟域处理，延时两拍
reg [2:0] Echo_delay;
always @ (posedge clk_50M or negedge s_rst_n)
begin
if(!s_rst_n)
	begin
		Echo_delay <= 'd0;
	end
else 
	begin
		Echo_delay <= {Echo_delay[1:0],Echo};
	end
end 
//检测上升沿下降沿
wire nege_Echo;
wire pose_Echo;
assign pose_Echo = (~Echo_delay[2])&&Echo_delay[1];
assign nege_Echo = Echo_delay[2]&&(!Echo_delay[1]);
//产生计数使能信号
reg cnt_17M_en;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		cnt_17M_en <= 'd0;
	else 
		if(pose_Echo)
			cnt_17M_en <= 1'b1;
		else 
			if(nege_Echo)
				cnt_17M_en <= 1'b0;
			else 
				cnt_17M_en <= cnt_17M_en;
end
//////////////////////////////////////////////////////////////////////////////////
//div_clk_17Mhz
reg [11:0] cnt_17M;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		cnt_17M <= 'd0;
	else 
		if(cnt_17M_en)
			begin
				if(cnt_17M == 'd2942)
					cnt_17M <= 'd0;
		        else 
		        	cnt_17M <= cnt_17M + 1'b1;
			end
		else 
			cnt_17M <= 'd0;
end 
reg clk_17M;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		clk_17M <= 1'b0;
	else 
		if(cnt_17M == 'd2942)
			clk_17M <= 1'b1;
		else 
			clk_17M <= 1'b0;
end
//////////////////////////////////////////////////////////////////////////////////
//generate trig 
reg [31:0] cnt_500Ms;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		cnt_500Ms <= 1'b0;
	else 
		if(cnt_500Ms == 'd12_500_000)
			cnt_500Ms <= 'd0;
		else 
			cnt_500Ms <= cnt_500Ms + 1'b1;
end
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		trig <= 1'b0;
	else 
		if(cnt_500Ms <= 'd900)
			trig <= 1'b1;
		else 
			trig <= 1'b0;
end 
//显示部分，使用计数器进行计数（17MHz）
reg [15:0] data_r;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		data_r <= 'd0;
	else 
		if(clk_17M == 1'b1)
			begin
				if(data_r[3 :0 ] == 'd9)
					begin
						data_r[7 :4 ] <= 1'b1 + data_r[7 :4 ];
						data_r[3 :0 ] <= 'd0;
					end 
				else 
					if(data_r[7 :4 ] == 'd9)
						begin
							data_r[11:8 ] <= 1'b1 + data_r[11:8 ];
							data_r[7 :4 ] <= 'd0;
						end 
					else 
						if(data_r[11:8 ] == 'd9)
							begin
								data_r[15:12] <= 1'b1 + data_r[15:12];
								data_r[11:8 ] <= 'd0;
							end 
						else 
							data_r <= data_r + 1'b1;
			end 
		else 
			if(cnt_500Ms == 'd12_500_000)
				data_r <= 'd0;
			else
				data_r <= data_r;
end 

always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		data <= 'd0;
	else 
		if(cnt_500Ms == 'd12_499_999)
			data <= data_r;
		else 
			data <= data ;
end 


endmodule
