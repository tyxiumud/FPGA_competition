`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:58 10/27/2019 
// Design Name: 
// Module Name:    uart_tx 
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
module uart_tx_v(
	input	clk,						//系统时钟
	input   rst_n,						//系统复位
	input	in,							//总使能
	input	[7:0]	data_rx,			//rx传来的处理过得数据
	input	EN,							//有效使能
	input	clk_bps,					//clk_bps控制的反馈的拍子
	output data_tx,						//接收来的数据处理后，一位一位的输出出去
	output reg bps_start				//标志位，启动clk_bps模块，调节时钟
    );
	
reg [7:0]	data_rx_r;					//用来接收传过来的data_rx
reg tx_en;								//一位数据传输使能
reg [3:0]num;							//发送bit的计数信号

always@(posedge clk)
begin
	if(!rst_n)
	begin
		tx_en <= 1'b0;
		bps_start <= 1'b0;
		data_rx_r <= 8'd0;
	end
	
	else if(!in)
	begin
		tx_en <= 1'b0;
		bps_start <= 1'b0;
		data_rx_r <= 8'd0;
	end
	
	else if(num == 4'd10)
	begin
		tx_en <= 1'b0;
		bps_start <= 1'b0;
	end
	else	if	(EN)
	begin	
		tx_en <=	1'b1;
		bps_start <= 1'b1;
		data_rx_r <= data_rx;
	end
end

reg data_tx_r;



always@(posedge clk)
begin
	
	if(!rst_n)	
	begin
		num <= 4'd0;
		data_tx_r <= 1'd0;
	end
	else if(!in)	
	begin
		num <= 4'd0;
		data_tx_r <= 1'd0;
	end
	else	if(tx_en)
	begin
		if(clk_bps)
		begin
		num <= num + 1'b1;
			case(num)
				4'd0: data_tx_r <= 1'b0; 				//发送起始位
				4'd1: data_tx_r <= data_rx_r[0];		//发送bit0
				4'd2: data_tx_r <= data_rx_r[1];		//发送bit1
				4'd3: data_tx_r <= data_rx_r[2];		//发送bit2
				4'd4: data_tx_r <= data_rx_r[3];		//发送bit3
				4'd5: data_tx_r <= data_rx_r[4];		//发送bit4
				4'd6: data_tx_r <= data_rx_r[5];		//发送bit5
				4'd7: data_tx_r <= data_rx_r[6];		//发送bit6
				4'd8: data_tx_r <= data_rx_r[7];		//发送bit7
				4'd9: data_tx_r <= 1'b1;				//发送结束位
			 	default: data_tx_r <= 1'b1;
			endcase
		end 
		else if(num == 4'd10) num <= 4'd0;			//复位
	end
end

assign data_tx = data_tx_r;
	
endmodule
