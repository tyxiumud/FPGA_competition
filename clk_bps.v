`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:24 10/27/2019 
// Design Name: 
// Module Name:    clk_bps 
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
module clk_bps_v(
	input	clk,						//系统时钟
	input   rst_n,						//系统复位
	input	in,							//总使能
	input	bps_start,					//标志位，启动clk_bps模块，调节时钟
	output	clk_bps						//clk_bps控制的反馈的拍子
    );

`define	CLK_PERIOD	20											//	时钟周期为20ns（50MHZ）
`define	BPS_SET		96
`define	BPS_PA (10_000_000/`CLK_PERIOD/`BPS_SET)	   //10_000_000/`CLK_PERIORD/96;   波特率为9600时的分频计数值	
																		//	1s=1000_000_000ns	f1=1s/20ns	上下同时约去个100就变成500_000/96
`define	BPS_PA_2	(`BPS_PA/2)									//BPS分频计数的1/2

reg [12:0]cnt;

always@(posedge clk)
begin
	
	if(!rst_n)		
		cnt <= 13'd0;
	else if(!in)		
		cnt <= 13'd0;
	else if(cnt ==	`BPS_PA || !bps_start )	
				cnt <=	13'd0;
	else cnt	<=	cnt +	1'b1;
end

reg clk_bps_r;

always@(posedge clk)
begin
	if(!rst_n)	
		clk_bps_r <= 1'b0;
	else if(!in)	
		clk_bps_r <= 1'b0;
	else if(cnt	==	`BPS_PA_2)	
				clk_bps_r	<=	1'b1;
	else clk_bps_r	<=	1'b0;
end

assign clk_bps	= clk_bps_r;
endmodule

