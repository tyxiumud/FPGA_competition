`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/06 23:47:48
// Design Name: 
// Module Name: TOP_voice_display
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


module TOP_voice_display(
	input 		clk_50M			, 	
	input 		s_rst_n			,
	//按摩打开播放使能
	input  		display_1_en 	,
	//PYNQ的uart数据传输(单独模块)
	input 		data_rx_pynq	,
	//危险气体播放使能信号
 	input 		display_2_en 	,
 	//RTC模块时间报时功能
 	input 		display_3_en 	,
 	input 		display_4_en 	,
 	//倒车辅助语音播报使能
 	input 		display_5_en 	,
	//语音输出tx
	output 		data_tx_voice 	,
	//超声波模块送来的一个时钟脉冲的高信号（不严格定义为1个）
	input 		meter_1_en 		,
	input 		cm_20_en 		,
	input 		meter_0_5_en 	,
	output 		vbrator_en	
    );
reg [3:0]  		select_voice 		;
reg 	 		select_voice_en 	;
TOP_voice TOP_voice_display_0(
	.clk_50M					(clk_50M			),
	.s_rst_n 					(s_rst_n			),
	.data_tx 					(data_tx_voice		),
	.select_voice 				(select_voice 		),
	.select_voice_en 			(select_voice_en	)
    );
wire data_1_en	;
wire data_2_en	;
pynq_uart_detect pynq_uart_detect_0(
	.clk_50M 					(clk_50M			),
	.s_rst_n 					(s_rst_n			),
	.rx_data 					(data_rx_pynq		),
	.data_1_en 					(data_1_en			),
	.data_2_en					(data_2_en			)
    );
assign vbrator_en = data_1_en;
wire meter_1_en ;
wire meter_0_5_en;
wire cm_20_en	;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		begin
			select_voice 	<= 4'd0;
			select_voice_en <= 1'b0;
		end
	else if(data_1_en == 1'b1) 		//可能检测到疲劳
			begin
				select_voice_en <= 1'b1		;
				select_voice 	<= 4'd5		;
			end
	else if(data_2_en == 1'b1) 		//系统开始工作
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd14	;
			end
	else if(display_1_en == 1'b1)	//播放按摩已打开
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd1 	;
			end
	else if(display_2_en == 1'b1)	//危险气体播报
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd6 	;
			end
	else if(display_3_en == 1'b1)	//已行驶3.5个小时
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd3 	;
			end
	else if(display_4_en == 1'b1)	//已行驶1.5个小时
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd4 	;
			end
	else if(display_5_en == 1'b1)	//倒车辅助语音播报使能
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd2 	;
			end
	else if(meter_1_en== 1'b1)	//一米警报
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd7 	;
			end
	else if(meter_0_5_en== 1'b1)	//0.5米警报
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd8 	;
			end
	else if(cm_20_en== 1'b1)	//20cm警报
			begin
				select_voice_en <= 1'b1 	;
				select_voice 	<= 4'd9 	;
			end	
		else
			begin
				select_voice_en <= 1'b0 	;
				select_voice 	<= select_voice ;
			end
		
end



endmodule
