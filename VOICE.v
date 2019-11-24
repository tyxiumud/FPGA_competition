`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:16 10/27/2019 
// Design Name: 
// Module Name:    VOICE 
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
module VOICE_v(
	input clk,					//系统时钟
	input rst_n,				//系统复位
	input [3:0]select_voice,			//发送选择
	output	data_tx				//发送数据
 );
 
	wire in;					//使能信号
	wire [7:0] data1;		
								//指令第一位数据
	wire [7:0] data2;
								//指令第二位数据
	wire [7:0] data3;
								//指令第三位数据
	wire [7:0] data4;
								//指令第四位数据
	wire [7:0] data5;
								//指令第五位数据
	wire [7:0] data6;
								//指令第六位数据
	wire [47:0] data;
								//传输指令
	wire [7:0] data_rx;
								//rx传来的处理过得数据
	wire s1,s2,s3,s4,s5,s6,s7,s8,s9;
								//s每次in播放前的曲目选择:select[0-10]
	wire f0,f1,f2,f3,f4,f5;
								//f功能选择:select[11-15]
	wire bps_start2;
								//标志位，启动clk_bps模块，调节时钟
	wire clk_bps2;
								//clk_bps控制的反馈的拍子
	wire EN;
								//有效使能
 
	//UART输出
	uart_tx_v	uut_uart_tx(
	.clk(clk),
	.rst_n(rst_n),
	.in(in),
	.data_rx(data_rx),						
	.clk_bps(clk_bps2),
	.EN(EN),					
	.data_tx(data_tx),
	.bps_start(bps_start2)		
    );

	//波特率
	clk_bps_v	uut_bps2(
	.clk(clk),
	.rst_n(rst_n),
	.in(in),
	.bps_start(bps_start2),
	.clk_bps(clk_bps2)
    );
	
	//翻译：将指令信号转为四十八位二进制数
	select_v uut_selset(
    .clk(clk), 
    .rst_n(rst_n), 
    .in(in), 
    .s1(s1), 
    .s2(s2), 
    .s3(s3), 
    .s4(s4), 
    .s5(s5), 
    .s6(s6), 
    .s7(s7), 
    .s8(s8), 
    .s9(s9), 
	.f0(f0),
    .f1(f1), 
    .f2(f2), 
    .f3(f3), 
    .f4(f4), 
    .f5(f5), 
    .data(data)
    );

	//四十八位二进制数分成可UART传输的六个八位宽二进制数
	decomposes_v uut_decomposes(
	.clk(clk),
	.rst_n(rst_n),
	.in(in),
	.data(data),
	.data1(data1),
	.data2(data2),
	.data3(data3),
	.data4(data4),
	.data5(data5),
	.data6(data6)
	);
	
	//并行的六个八位宽二进制数变成串行给UART输入
	queueing_v uut_queueing(
	.clk(clk),
	.rst_n(rst_n),
	.in(in),
	.data1(data1),
	.data2(data2),
	.data3(data3),
	.data4(data4),
	.data5(data5),
	.data6(data6),
	.EN(EN),
	.data_rx(data_rx)
	);
	
	//信号转化：选择信号转化为对应指令
	input_sel_v uut_input_sel(
    .clk(clk), 
    .rst_n(rst_n), 
    .select(select_voice), 
    .s1(s1), 
    .s2(s2), 
    .s3(s3), 
    .s4(s4), 
    .s5(s5), 
    .s6(s6), 
    .s7(s7), 
    .s8(s8), 
    .s9(s9), 
	.f0(f0),
    .f1(f1), 
    .f2(f2), 
    .f3(f3), 
    .f4(f4), 
    .f5(f5)
    );
	
endmodule
