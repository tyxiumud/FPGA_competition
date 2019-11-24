`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/19 01:06:04
// Design Name: 
// Module Name: VGA_data_generate
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


module VGA_data_generate(
	input  						mclk 		,
	input 						s_rst_n 	, 
	input 			[9:0]		x_cnt		,
	input  			[9:0]		y_cnt		,
	input  						vidon 		,
	input 			[15:0]		doutb_ram  	,
	input 						CAM_en 		,
	output reg		[15:0]		rgb  		,
	//当前的时间
	input 			[23:0] 		data_time_now,
	//使用的时间
	input 			[23:0] 		time_pass_data,
	//送入的烟雾检测状态，持续的电平信号
	input 						yanwu_en 	,
	//按摩使能
	input 						anmo_en  	,
	input 						music_en 	,
	input 						pilao_en 		
    );




parameter Hor_Total_Time 		= 800	;		//行显示帧长
parameter Hor_Sync		 		= 96	;		//行同步脉冲
parameter Hor_Back_Porch 		= 48	;		//行显示后沿（同显示前沿，这里由两个时段合成）	
parameter Hor_Addr_Time 		= 640	;		//行显示区域
parameter Hor_Front_Porch		= 16	;		//行显示前沿
parameter Ver_Total_Time 		= 525	;		//列显示帧长
parameter Ver_Sync		 		= 2		;		//列同步脉冲
parameter Ver_Back_Porch 		= 33	;		//列显示后沿（同显示前沿，这里由两个时段合成）	
parameter Ver_Addr_Time 		= 480	;		//列显示区域
parameter Ver_Front_Porch		= 10	;		//列显示前沿
//ROM paramater
reg [511:0] char1	[31:0] ; 		//为您的出行安全护航
reg [127:0] char2	[31:0] ; 		//音乐播放
reg [63:0 ] char3	[31:0] ; 		//按摩
reg [127:0] char4	[31:0] ; 		//烟雾检测
reg [127:0] char5	[31:0] ; 		//疲劳检测
reg [63:0 ] char6	[31:0] ; 		//打开
reg [63:0 ] char7	[31:0] ; 		//关闭
reg [63:0 ] char8	[31:0] ; 		//正常
reg [63:0 ] char9	[31:0] ; 		//警报
reg [127:0] char10 	[31:0] ; 		//当前时间
reg [159:0] char11 	[31:0] ; 		//当前时间
reg [511:0] char12	[10:0] ; 		//显示的数字


//wire music_en = 1'b1;					//音乐打开显示使能
//wire anmo_en = 1'b1; 					//按摩打开显示使能
//wire pilao_en ;							//疲劳打开使能
//wire yanwu_en ; 						//烟雾打开是是使能

always@(*)
begin
	if(vidon)
		begin
			if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 64 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 512 + 64 - 1'b1)) //为您的出行安全护航
				&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 104 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 104 + 32  - 1'b1) 
				&& (CAM_en != 1'b1))
				begin
					if(char1[y_cnt - (Ver_Sync + Ver_Back_Porch + 104 - 1'b1)]['d511 + Hor_Sync + Hor_Back_Porch + 64 - 1'b1- x_cnt])
						rgb <= 16'h0000;
					else 
						rgb <= 16'hffff;
				end
			else 
				if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*4 + 50 - 1'b1)) //音乐播放
						&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32 - 1'b1 ) 
						&& (CAM_en != 1'b1) )
					begin
						if(char2[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d127 + Hor_Sync + Hor_Back_Porch + 50 - 1'b1- x_cnt])
							rgb <= 16'h0000;
						else 
							rgb <= 16'hffff;
					end
				else 
					if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 32*5 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*7 + 50 - 1'b1)) //音乐打开显示
						&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32 - 1'b1 ) 
						&& (CAM_en != 1'b1) )
						begin
							if(music_en && (CAM_en != 1'b1) )
								if(char6[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
									rgb <= 16'h0000;
								else 
									rgb <= 16'hffff;
							else 
								if(char7[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
									rgb <= 16'h0000;
								else 
									rgb <= 16'hffff;
						end
					else 
						if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*4 + 50 + 320 - 1'b1)) //当前时间
							&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32 - 1'b1 ) 
							&& (CAM_en != 1'b1) )
							begin
								if(char10[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 + 32*2 - 1'b1 )]['d127 + Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1 - x_cnt])
									rgb <= 16'h0000;
								else 
									rgb <= 16'hffff;
							end
						else 
							if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*2 + 50 - 1'b1)) //按摩
								&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 ) 
								&& (CAM_en != 1'b1) )
								begin
									if(char3[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 + 32*2 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 - 1'b1- x_cnt])
										rgb <= 16'h0000;
									else 
										rgb <= 16'hffff;
								end
							else 
								if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 32*5 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*7 + 50 - 1'b1)) //按摩打开显示
									&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
									&& (CAM_en != 1'b1) )
									begin
										if(anmo_en && (CAM_en != 1'b1) )
											if(char6[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										else 
											if(char7[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
									end
								else 
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16 + 50 + 320 - 1'b1)) //时间位置左0
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[data_time_now[23:20]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*2 + 50 + 320 - 1'b1)) //时间位置左1
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[data_time_now[19:16]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*2 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*3 + 50 + 320 - 1'b1)) //时间位置左2
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[10][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else 
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*3 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*4 + 50 + 320 - 1'b1)) //时间位置左3
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[data_time_now[15:12]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*4 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*5 + 50 + 320 - 1'b1)) //时间位置左4
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[data_time_now[11:8]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else 
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*5 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*6 + 50 + 320 - 1'b1)) //时间位置左5
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[10][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else 
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*6 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*7 + 50 + 320 - 1'b1)) //时间位置左6
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[data_time_now[7:4]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else 
									if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*7 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*8 + 50 + 320 - 1'b1)) //时间位置左7
										&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*3 - 1'b1 )
										&& (CAM_en != 1'b1) )
										begin
											if(char12[data_time_now[3:0]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*2 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
												rgb <= 16'h0000;
											else 
												rgb <= 16'hffff;
										end
									else   
										if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*4 + 50 - 1'b1)) //烟雾检测
											&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*4 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*5 - 1'b1 ) 
											&& (CAM_en != 1'b1) )
											begin
												if(char4[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 + 32*4 - 1'b1 )]['d127 + Hor_Sync + Hor_Back_Porch  + 50 - 1'b1- x_cnt])
													rgb <= 16'h0000;
												else 
													rgb <= 16'hffff;
											end
										else 
											if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*5 + 50 + 320- 1'b1)) //已行驶时间
												&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*4 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*5 - 1'b1 ) 
												&& (CAM_en != 1'b1) )
												begin
													if(char11[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 + 32*4 - 1'b1 )]['d159 + Hor_Sync + Hor_Back_Porch  + 50 + 320- 1'b1- x_cnt])
														rgb <= 16'h0000;
													else 
														rgb <= 16'hffff;
												end
											else 
												if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 32*5 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*7 + 50 - 1'b1)) //烟雾打开显示
													&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*4 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*5 - 1'b1 ) 
													&& (CAM_en != 1'b1) )
													begin
														if(!yanwu_en && (CAM_en != 1'b1) )
															if(char9[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
																rgb <= 16'h0000;
															else 
																rgb <= 16'hffff;
														else 
															if(char8[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
																rgb <= 16'h0000;
															else 
																rgb <= 16'hffff;
													end
												else 
													if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*4 + 50 - 1'b1)) //疲劳检测
														&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 ) 
														&& (CAM_en != 1'b1) )
														begin
															if(char5[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 + 32*6 - 1'b1 )]['d127 + Hor_Sync + Hor_Back_Porch  + 50 - 1'b1- x_cnt])
																rgb <= 16'h0000;
															else 
																rgb <= 16'hffff;
														end
													else
														if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 32*5 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 32*7 + 50 - 1'b1)) //疲劳打开显示
															&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 ) 
															&& (CAM_en != 1'b1) )
															begin
																if((pilao_en == 1'b1) && (CAM_en != 1'b1) )
																	if(char9[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																else 
																	if(char8[y_cnt - (Ver_Sync + Ver_Back_Porch + 250 - 1'b1 )]['d63 + Hor_Sync + Hor_Back_Porch  + 50 + 32*5 - 1'b1- x_cnt])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
															end
														else 
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*0 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*1 + 50 + 320 - 1'b1)) //时间位置左0
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[time_pass_data[23:20]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else 
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*1 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*2 + 50 + 320 - 1'b1)) //时间位置左1
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[time_pass_data[19:16]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*2 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*3 + 50 + 320 - 1'b1)) //时间位置左2
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[10][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*3 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*4 + 50 + 320 - 1'b1)) //时间位置左3
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[time_pass_data[15:12]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*4 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*5 + 50 + 320 - 1'b1)) //时间位置左4
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[time_pass_data[11:8]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*5 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*6 + 50 + 320 - 1'b1)) //时间位置左5
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[10][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*6 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*7 + 50 + 320 - 1'b1)) //时间位置左6
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[time_pass_data[7:4]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else
															if( (x_cnt >= (Hor_Sync + Hor_Back_Porch + 50 + 16*7 + 320 - 1'b1)) && (x_cnt <= (Hor_Sync + Hor_Back_Porch + 16*8 + 50 + 320 - 1'b1)) //时间位置左7
																&& (y_cnt >= Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1 ) && (y_cnt <= Ver_Sync + Ver_Back_Porch + 250 + 32*7 - 1'b1 )
																&& (CAM_en != 1'b1) )
																begin
																	if(char12[time_pass_data[3:0]][ (32 + Ver_Sync + Ver_Back_Porch + 250  + 32*6 - 1'b1  - y_cnt)*16 - ((x_cnt-Hor_Sync + Hor_Back_Porch + 50 + 320 - 1'b1)%16) -1 ])
																		rgb <= 16'h0000;
																	else 
																		rgb <= 16'hffff;
																end
															else
																if(CAM_en != 1'b1)
																	rgb <= 16'hffff;
																else 
																	if(CAM_en == 1'b1 )
																		rgb <= doutb_ram;
																	else 
																		rgb <= rgb ;
		end			
	else 
		rgb <= 16'd0;
end

always @ (posedge mclk)
begin 
	char1[0 ] <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	char1[1 ] <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	char1[2 ] <= 512'h0000000000001E000000000000000000000000000000007800000F1E000003C000000000F000001E000000001E00000007800000F01E00001E00000000000000;
	char1[3 ] <= 512'h00001F3E00001F800000780000000000000000000000007F00000FDF800003F01F000000FC00003F000000000F80000007E00000FC0F80001F81C00000000000;
	char1[4 ] <= 512'h00003F7C00003F0007FFFFFFF81FDF80000000000000F07C00001F1F000003E03F000000F800003E000380000FC000000FC00000F803C0001F00F80000000000;
	char1[5 ] <= 512'h00007EF800003E78007F87C0F01FFF800000000000007C7C00001F3E000003C03E000000F800007C7FFFC00007C000000FE00000F803F0001E007C0000000000;
	char1[6 ] <= 512'h0000FDF81E3C7FFC007F87C0F01FFF800000000000003E7C00003E3E01E003C03E000000F87800780000000007C000001FF00000F801C001FDE07C0003F00000;
	char1[7 ] <= 512'h0001FBF00FFE7CF8007F87C0F01FDF800000000000003F7C00003E7FFFF03F9E7C0003E0F87E00F00000003C0780F8001FF80000F8F1C780FFF003E003F00000;
	char1[8 ] <= 512'h0001F3F00F7CF9F003FF87C0F0038F800000000000001F7C00007E7801F03FFF7C3C03E0F87C01EF0000003FFFFFFC003E7C0000FFFFFFC0F1FFFFF003F00000;
	char1[9 ] <= 512'h0001FFF80F7CF1E003FFFFFFF00F8F00000000000000007C00007EF803E03E3E7FFE03E0F87C03CF8000003C0000F8007C3E003FFFF807C0FDE0000003F00000;
	char1[10] <= 512'h0003FFFC0F7DC3E003FFFFC0F00F1E00000000000000007C01E0FEF0FBC03E3EF87E03E0F87C079F8000007C3C01F000F81F0000F8F807C0FFE0000003F00000;
	char1[11] <= 512'h0001FFFC0F7FC3C003FFFFC0F01E3C0000000000000FFFFFFFF1FFE0F8003E3EF07C03E0F87C001F0001F0FC3F01C000F80F8000F8F807C0FFE0000003F00000;
	char1[12] <= 512'h0001FFF80F7FFFFF83FFFFC0F03C780000000000000000F803E1FFFEF8003E3FF07C03E0F87C003FFFFFF8003E000001F003F000F8F807C0FFEF0F0003F00000;
	char1[13] <= 512'h000000700F7CF7DF03FFFFFFF000000000000000000000F803E3BE3EFF003E3FC07C03E0F87C007C00F800007C007803C003FE00F8F807C0FFEFFF8003F00000;
	char1[14] <= 512'h000000000F7CF7DF03FFFFC0F000000000000000000000F803E03E7CFFC03E3F807C03E0F87C007C00F800007C00FC1FFFFFFFC0FFF807C0F1EF9F0003F00000;
	char1[15] <= 512'h000000000F7CF7DF03FFF8000000000000000000000001F003E03EF8FBE03E3F787C07FFFFFC00FE00F803FFFFFFFE3E03E03F00FFFFFFC0F1EF9F0001E00000;
	char1[16] <= 512'h000000000F7CF7DF03FFFFBE0000000000FFFFFFFFE001FE03E03FF0F9F03E3E7C7C03C0F87C01FC00F80000F83E00F803E00001FCF807DFFFEF9F0001E00000;
	char1[17] <= 512'h000000000F7CF7DF03FFFFFC0000000000000000000001FF83E03FFDF9F03FFE3E7C0000F80003FC00F80000F83E01E003E0000FF8F80780F1EF9F0001E00000;
	char1[18] <= 512'h000000000F7CF79F03F3FFFCF800000000000000000003E3F3E03E1FF0003E3E3E7C0000F80007FC00F80001F07C000003E0003FF8F00000FDEF9F0001E00000;
	char1[19] <= 512'h000000000FFCF79FC3E0FFFFF800000000000000000003E1FBE03E03F0003E3E3F7C0780F83C0FBC00F80001F07C000003E0003EF8F00000FFEF9F0001E00000;
	char1[20] <= 512'h000000000F7FFFFFF3E0FFBC0000000000000000000007C0FFE03C7800003E3E1F7C07C0F83F003C00F80003C0F8000003E1C000F9F00000FFEF9F0001E00000;
	char1[21] <= 512'h000000000F7C0FC003E0FF3C0000000000000000000007C07FC003FE00003E3E1E7C07C0F83E003C00F80003C1F8000FFFFFF000F9F00001FFEF9F0000000000;
	char1[22] <= 512'h000000000F780FE003FFFE3CF00000000000000000000F807FC003FF07803E3E007C07C0F83E003C00F80001FDF0000003E00000F9E00001FFEF9F0000000000;
	char1[23] <= 512'h000000000F001FE003E0FFFFF80000000000000000001F0007C03FEF83E03E3E007C07C0F83E003C00F800003FE0000003E00000FBE00001F1EF1F0003E00000;
	char1[24] <= 512'h000000001E001EF003E0FC3C000000000000000000003F0007C07FEF8FF03E3E007C07C0F83E003C00F8000007F8000003E00000FBE00001C1EF1FF007F00000;
	char1[25] <= 512'h0000000000003E7803E0F83C000000000000000000003E0007C07FE00FF83E3E007C07C0F83E003C00F800000FFE000003E00000FBC00001C1FF1FF007F00000;
	char1[26] <= 512'h0000000000007C7E03E0F83C000000000000000000007C0007C0FBE00FF83E3E007C07C0F83E003C00F800001F3FC00003E00000FF800003C1FE1FF003E00000;
	char1[27] <= 512'h000000000000F83F03FFF83C00000000000000000000F00F8FC1FBE01F783FFE1EFC07C0F83E003C3FF800007E0FF00003E0003CFF80000381FE1FF800000000;
	char1[28] <= 512'h000000000001F01FF3E0F83C78000000000000000003C001FF8003E03F803E3E0FF80FFFFFFE003C0FF00001F801F80003E03E1FFF00000F0FFC0FFC00000000;
	char1[29] <= 512'h00000000001F8003C3E0FFFFFC00000000000000000F80007F0001FFFF003E3E03F80780003E003C03F0001FC000F87FFFFFFF03FE00000F07F80FF800000000;
	char1[30] <= 512'h00000000007C000003C0F0000000000000000000001E00003E0000000000000001E00000003E007803C001FC0000000000000001FC00001E00F0000000000000;
	char1[31] <= 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
end 


always @ (posedge mclk)
begin 
	char2[0 ] <= 128'h00000000000000000000000000000000;
	char2[1 ] <= 128'h00000000000000000000000000000000;
	char2[2 ] <= 128'h00070000000000000100004000000800;
	char2[3 ] <= 128'h0003C00000000180018003E001001C00;
	char2[4 ] <= 128'h0003C0C000000FC001807F0000C01800;
	char2[5 ] <= 128'h0001C1E00103FE000187880000E01800;
	char2[6 ] <= 128'h0FFFFFF001FC00000181086000601800;
	char2[7 ] <= 128'h06600C0001800000018188C000601000;
	char2[8 ] <= 128'h00301E000180C0000190C88000033018;
	char2[9 ] <= 128'h003C1E000100E0003FF8C9803FFFBFFC;
	char2[10] <= 128'h003C1C000300C0000180891803002060;
	char2[11] <= 128'h001C38000300C000018FFFFC03006060;
	char2[12] <= 128'h001C38180300C00001803A0003006060;
	char2[13] <= 128'h001C307C0300C0000180690003046040;
	char2[14] <= 128'h7FFFFFFE0300C0300190C98003FEA0C0;
	char2[15] <= 128'h3000000007FFFFF801A18860030490C0;
	char2[16] <= 128'h000000000200C00001C3083C030410C0;
	char2[17] <= 128'h01C003800000C0000384102803041080;
	char2[18] <= 128'h01FFFFC00000C000078BFFF0020C1980;
	char2[19] <= 128'h01E003800030C4001DB30860020C0980;
	char2[20] <= 128'h01E003800038C20039830860020C0900;
	char2[21] <= 128'h01E003800060C18021830860060C0700;
	char2[22] <= 128'h01E0038000C0C0C001830860060C0600;
	char2[23] <= 128'h01FFFF800180C0E00183FFE0040C0700;
	char2[24] <= 128'h01E003800300C07001830860040C0F00;
	char2[25] <= 128'h01E003800600C030018308600C0C1980;
	char2[26] <= 128'h01E003800C00C03001830860099830E0;
	char2[27] <= 128'h01FFFF801010C030018308601078C070;
	char2[28] <= 128'h01E00380200FC0001F83FFE01031803E;
	char2[29] <= 128'h01E003800003C0000703006020060018;
	char2[30] <= 128'h01C00380000100000202000040080000;
	char2[31] <= 128'h00000000000000000000000000000000;
end 

always @ (posedge mclk)
begin 
	char3[0 ] <= 64'h0000000000000000;
	char3[1 ] <= 64'h0000000000000000;
	char3[2 ] <= 64'h0380300000008000;
	char3[3 ] <= 64'h03C03C000000C000;
	char3[4 ] <= 64'h03801C0000006010;
	char3[5 ] <= 64'h03801E0007FFFFF8;
	char3[6 ] <= 64'h03831C1806080600;
	char3[7 ] <= 64'h0387FFFC060C0600;
	char3[8 ] <= 64'h03F7003C06080610;
	char3[9 ] <= 64'h7FFF303807FFFFF8;
	char3[10] <= 64'h238F3C7006180F00;
	char3[11] <= 64'h03847860063E1E80;
	char3[12] <= 64'h03807000062B36C0;
	char3[13] <= 64'h0398700006492660;
	char3[14] <= 64'h03F0E03804C84638;
	char3[15] <= 64'h03FFFFFC04888618;
	char3[16] <= 64'h0781E1E005080A00;
	char3[17] <= 64'h1F81C1E004101F00;
	char3[18] <= 64'h7F83C1C0043FFC00;
	char3[19] <= 64'h3B8383C00C006000;
	char3[20] <= 64'h338383800C006080;
	char3[21] <= 64'h038787800C7FFFC0;
	char3[22] <= 64'h0383FF8008006000;
	char3[23] <= 64'h03807F0008006010;
	char3[24] <= 64'h03800F801FFFFFF8;
	char3[25] <= 64'h03801FE010006000;
	char3[26] <= 64'h03807DF810006000;
	char3[27] <= 64'h1380F07820006000;
	char3[28] <= 64'h3F83E03C2007C000;
	char3[29] <= 64'h0F9F001C4001C000;
	char3[30] <= 64'h0778000000008000;
	char3[31] <= 64'h0000000000000000;
end 

always @ (posedge mclk)
begin 
	char4[0 ] <= 128'h00000000000000000000000000000000;
	char4[1 ] <= 128'h00000000000000000000000000000000;
	char4[2 ] <= 128'h03800000000001000200100008000010;
	char4[3 ] <= 128'h03C6001C01FFFF80038038000C200018;
	char4[4 ] <= 128'h0387FFFE0001800003003800063FF018;
	char4[5 ] <= 128'h0387081C040180100300380003303018;
	char4[6 ] <= 128'h03870E1C07FFFFF80300640003303018;
	char4[7 ] <= 128'h039F0E1C040180300300660000303318;
	char4[8 ] <= 128'h03BF0E1C0CF99F200310C20000323398;
	char4[9 ] <= 128'h03BF0E1C1C0180407FF883800033B318;
	char4[10] <= 128'h1BF70E1C00F99F00030181C030333318;
	char4[11] <= 128'h1BE70FDC00018000030300F018B33318;
	char4[12] <= 128'h3BC7FFFC001000000306007E1CB33318;
	char4[13] <= 128'h3B876E1C0038000003CC00900CB33318;
	char4[14] <= 128'h3B870E1C007FFE000773FFC009333318;
	char4[15] <= 128'h7B870E1C00D00E000730008001333318;
	char4[16] <= 128'h73871E1C018818000730006001323318;
	char4[17] <= 128'h03871E1C020660000F1020E001323318;
	char4[18] <= 128'h03871F1C0C01C0000B0030C002323318;
	char4[19] <= 128'h03871F9C000E7C001B0410C002323318;
	char4[20] <= 128'h03873BDC00720FF8130218C006323318;
	char4[21] <= 128'h07E739FC0F8300F0230318807E362318;
	char4[22] <= 128'h07F731FC30030100230319801C260318;
	char4[23] <= 128'h077F70DC01FFFF80430119800C050318;
	char4[24] <= 128'h063FE0DC00060300030181000C0C8018;
	char4[25] <= 128'h0E3FC01C00060300030101000C084018;
	char4[26] <= 128'h0C1F001C000C0300030002000C187018;
	char4[27] <= 128'h1C07FFFC00180200030002180C303018;
	char4[28] <= 128'h3807001C00304600033FFFFC0C6031F0;
	char4[29] <= 128'h3007001C01C03C000300000000801070;
	char4[30] <= 128'h600700181E0018000300000001000020;
	char4[31] <= 128'h00000000000000000000000000000000;
end 

always @ (posedge mclk)
begin 
	char5[0 ] <= 128'h00000000000000000000000000000000;
	char5[1 ] <= 128'h00000000000000000000000000000000;
	char5[2 ] <= 128'h0001C000001008000200100008000010;
	char5[3 ] <= 128'h0000F000001C0C00038038000C200018;
	char5[4 ] <= 128'h0000F01800180C0003003800063FF018;
	char5[5 ] <= 128'h0380703C00180C100300380003303018;
	char5[6 ] <= 128'h03FFFFFE00180C380300640003303018;
	char5[7 ] <= 128'h038030003FFFFFFC0300660000303318;
	char5[8 ] <= 128'h33803C0000180C000310C20000323398;
	char5[9 ] <= 128'h3B80380000180C007FF883800033B318;
	char5[10] <= 128'h3B9C383000180C00030181C030333318;
	char5[11] <= 128'h1F9FFFF804101010030300F018B33318;
	char5[12] <= 128'h1F9E387807FFFFF80306007E1CB33318;
	char5[13] <= 128'h1F9E38600404003803CC00900CB33318;
	char5[14] <= 128'h1B9E38C00C0300200773FFC009333318;
	char5[15] <= 128'h039E38001C0300400730008001333318;
	char5[16] <= 128'h039E3800000300000730006001323318;
	char5[17] <= 128'h1F9E38E0000300000F1020E001323318;
	char5[18] <= 128'h7F9FFFF007FFFFC00B0030C002323318;
	char5[19] <= 128'h7B9CC1E0000201801B0410C002323318;
	char5[20] <= 128'h339CC1C000060180130218C006323318;
	char5[21] <= 128'h039CE3C000060180230318807E362318;
	char5[22] <= 128'h039C638000060180230319801C260318;
	char5[23] <= 128'h073C7700000C0180430119800C050318;
	char5[24] <= 128'h07383F00000C0300030181000C0C8018;
	char5[25] <= 128'h07381E0000180300030101000C084018;
	char5[26] <= 128'h0E703F0000300300030002000C187018;
	char5[27] <= 128'h1CE0FFC000606700030002180C303018;
	char5[28] <= 128'h18E3E3FE01801E00033FFFFC0C6031F0;
	char5[29] <= 128'h39CF80FC06000E000300000000801070;
	char5[30] <= 128'h733C0018380008000300000001000020;
	char5[31] <= 128'h00000000000000000000000000000000;
end 

always @ (posedge mclk)
begin 
	char6[0 ] <= 64'h0000000000000000;
	char6[1 ] <= 64'h0000000000000000;
	char6[2 ] <= 64'h01C0000000000000;
	char6[3 ] <= 64'h01E0000000000020;
	char6[4 ] <= 64'h01C0001800000070;
	char6[5 ] <= 64'h01C0003C1FFFFFF8;
	char6[6 ] <= 64'h01C7FFFE00300C00;
	char6[7 ] <= 64'h01C1070000300C00;
	char6[8 ] <= 64'h01DC070000300C00;
	char6[9 ] <= 64'h7FFE070000300C00;
	char6[10] <= 64'h11C0070000300C00;
	char6[11] <= 64'h01C0070000300C00;
	char6[12] <= 64'h01C0070000300C00;
	char6[13] <= 64'h01C0070000300C00;
	char6[14] <= 64'h01DE070000300C18;
	char6[15] <= 64'h01F807003FFFFFFC;
	char6[16] <= 64'h03F0070000300C00;
	char6[17] <= 64'h1FC0070000300C00;
	char6[18] <= 64'h7FC0070000300C00;
	char6[19] <= 64'h3DC0070000300C00;
	char6[20] <= 64'h11C0070000300C00;
	char6[21] <= 64'h01C0070000200C00;
	char6[22] <= 64'h01C0070000600C00;
	char6[23] <= 64'h01C0070000600C00;
	char6[24] <= 64'h01C0070000C00C00;
	char6[25] <= 64'h01C0070000800C00;
	char6[26] <= 64'h01C0070001000C00;
	char6[27] <= 64'h3FC0FF0002000C00;
	char6[28] <= 64'h1FC07F0004000C00;
	char6[29] <= 64'h07C01E0018000C00;
	char6[30] <= 64'h03800C0020000800;
	char6[31] <= 64'h0000000000000000;
end 


always @ (posedge mclk)
begin 
	char7[0 ] <= 64'h0000000000000000;
	char7[1 ] <= 64'h0000000000000000;
	char7[2 ] <= 64'h00C00C0001000000;
	char7[3 ] <= 64'h00701F0000C00000;
	char7[4 ] <= 64'h00381F0000E00010;
	char7[5 ] <= 64'h003C1C000067FFF8;
	char7[6 ] <= 64'h001E3C000C604030;
	char7[7 ] <= 64'h001E38000E006030;
	char7[8 ] <= 64'h000C30200C007030;
	char7[9 ] <= 64'h000C70700C006030;
	char7[10] <= 64'h1FFFFFF80C006030;
	char7[11] <= 64'h0C03C0000C006130;
	char7[12] <= 64'h0003C0000CFFFFF0;
	char7[13] <= 64'h0003C0000C00E030;
	char7[14] <= 64'h000380000C01E030;
	char7[15] <= 64'h000380180C016030;
	char7[16] <= 64'h0003803C0C036030;
	char7[17] <= 64'h7FFFFFFE0C066030;
	char7[18] <= 64'h3003E0000C046030;
	char7[19] <= 64'h0007F0000C086030;
	char7[20] <= 64'h000770000C106030;
	char7[21] <= 64'h000F38000C206030;
	char7[22] <= 64'h000E38000C406030;
	char7[23] <= 64'h001E1C000D806030;
	char7[24] <= 64'h003C0E000C046030;
	char7[25] <= 64'h00780F800C03E030;
	char7[26] <= 64'h00F007C00C00C030;
	char7[27] <= 64'h03C003F00C008030;
	char7[28] <= 64'h078001FE0C0003F0;
	char7[29] <= 64'h1E00007C0C0000F0;
	char7[30] <= 64'h7800003808000060;
	char7[31] <= 64'h0000000000000000;
end 


always @ (posedge mclk)
begin 
	char8[0 ] <= 64'h0000000000000000;
	char8[1 ] <= 64'h0000000000000000;
	char8[2 ] <= 64'h0000000000010200;
	char8[3 ] <= 64'h0000003000818300;
	char8[4 ] <= 64'h0000007800618700;
	char8[5 ] <= 64'h0FFFFFFC00718400;
	char8[6 ] <= 64'h0601E00000318800;
	char8[7 ] <= 64'h0001E00000219018;
	char8[8 ] <= 64'h0001E0000FFFFFFC;
	char8[9 ] <= 64'h0001E00008000018;
	char8[10] <= 64'h0001E00008000030;
	char8[11] <= 64'h0001E00018400420;
	char8[12] <= 64'h01E1E000307FFE00;
	char8[13] <= 64'h01F1E04000600600;
	char8[14] <= 64'h01E1E0E000600600;
	char8[15] <= 64'h01E1FFF000600600;
	char8[16] <= 64'h01E1E000007FFE00;
	char8[17] <= 64'h01E1E00000618600;
	char8[18] <= 64'h01E1E00000018000;
	char8[19] <= 64'h01E1E00002018080;
	char8[20] <= 64'h01E1E00003FFFFC0;
	char8[21] <= 64'h01E1E000030180C0;
	char8[22] <= 64'h01E1E000030180C0;
	char8[23] <= 64'h01E1E000030180C0;
	char8[24] <= 64'h01E1E000030180C0;
	char8[25] <= 64'h01E1E000030180C0;
	char8[26] <= 64'h01E1E03003018CC0;
	char8[27] <= 64'h01E1E07803018380;
	char8[28] <= 64'h7FFFFFFC03018180;
	char8[29] <= 64'h3000000000018000;
	char8[30] <= 64'h0000000000018000;
	char8[31] <= 64'h0000000000000000;
end 


always @ (posedge mclk)
begin 
	char9[0 ] <= 64'h0000000000000000;
	char9[1 ] <= 64'h0000000000000000;
	char9[2 ] <= 64'h039C0C0001000000;
	char9[3 ] <= 64'h03DE1E0001C1FFC0;
	char9[4 ] <= 64'h03DDDC00018180C0;
	char9[5 ] <= 64'h7FFFDC1C018180C0;
	char9[6 ] <= 64'h37DC3FFE018180C0;
	char9[7 ] <= 64'h0F1B38E0018180C0;
	char9[8 ] <= 64'h0FFFFCE0019980C0;
	char9[9 ] <= 64'h1E33EDC07FFD80C0;
	char9[10] <= 64'h1FFBEFC001818F80;
	char9[11] <= 64'h3F3F878001818380;
	char9[12] <= 64'h67FF078001818000;
	char9[13] <= 64'h073F0FC001818020;
	char9[14] <= 64'h06071FFE018DFFF0;
	char9[15] <= 64'h003F78FE01F1A060;
	char9[16] <= 64'h001FE01803C1A040;
	char9[17] <= 64'h0009C0380F8190C0;
	char9[18] <= 64'h3FFFFFFC3D8190C0;
	char9[19] <= 64'h1800030031818980;
	char9[20] <= 64'h03FFFF8001818980;
	char9[21] <= 64'h0180030001818700;
	char9[22] <= 64'h01FFFF8001818600;
	char9[23] <= 64'h00C0000001818700;
	char9[24] <= 64'h0300030001818D80;
	char9[25] <= 64'h03FFFF80018198E0;
	char9[26] <= 64'h03C007000181B078;
	char9[27] <= 64'h03C007000181C03C;
	char9[28] <= 64'h03FFFF001F818000;
	char9[29] <= 64'h03C0070007018000;
	char9[30] <= 64'h0380070002000000;
	char9[31] <= 64'h0000000000000000;
end 
//当前时间
always @ (posedge mclk)
begin 
	char10[0 ] <= 128'h00000000000000000000000000000000;
	char10[1 ] <= 128'h00000000000000000000000000000000;
	char10[2 ] <= 128'h00038000004004000000020002000000;
	char10[3 ] <= 128'h0003E00000200E000000038001800000;
	char10[4 ] <= 128'h0403C18000380C000000030001C00010;
	char10[5 ] <= 128'h0703C3C0001808000020030000CFFFF8;
	char10[6 ] <= 128'h03C3C3E0001810001FF0030008C00030;
	char10[7 ] <= 128'h01E3C78000082018183003000E400030;
	char10[8 ] <= 128'h01F3C7003FFFFFFC183003000C000030;
	char10[9 ] <= 128'h00F3CE0000000000183003180C000030;
	char10[10] <= 128'h00E3DC00000000C0183FFFFC0C001830;
	char10[11] <= 128'h0003F800040400E0183003000C1FFC30;
	char10[12] <= 128'h0003C03807FF10C0183003000C181830;
	char10[13] <= 128'h1FFFFFFC060618C0183003000C181830;
	char10[14] <= 128'h0E000078060618C0183203000C181830;
	char10[15] <= 128'h00000078060618C01FF103000C181830;
	char10[16] <= 128'h00000078060618C01831C3000C1FF830;
	char10[17] <= 128'h0000007807FE18C01830C3000C181830;
	char10[18] <= 128'h00000078060618C01830E3000C181830;
	char10[19] <= 128'h00000078060618C0183043000C181830;
	char10[20] <= 128'h07FFFFF8060618C0183003000C181830;
	char10[21] <= 128'h0300007807FE18C0183003000C181830;
	char10[22] <= 128'h00000078060618C0183003000C1FF830;
	char10[23] <= 128'h00000078060618C01FF003000C181830;
	char10[24] <= 128'h00000078060618C0183003000C101030;
	char10[25] <= 128'h00000078060618C0183003000C000030;
	char10[26] <= 128'h0000007806060040180003000C000030;
	char10[27] <= 128'h00000078060600C0000003000C000030;
	char10[28] <= 128'h1FFFFFF8063C0FC000003F000C0003F0;
	char10[29] <= 128'h0C000078061C0380000007000C0000E0;
	char10[30] <= 128'h00000070040801000000060008000040;
	char10[31] <= 128'h00000000000000000000000000000000;
end 
//已行驶时间
always @ (posedge mclk)
begin 
	char11[0 ] <= 160'h0000000000000000000000000000000000000000;
	char11[1 ] <= 160'h0000000000000000000000000000000000000000;
	char11[2 ] <= 160'h0000000000400000000004000000020002000000;
	char11[3 ] <= 160'h0000018000E00000000007000000038001800000;
	char11[4 ] <= 160'h0FFFFFE000C00020001006000000030001C00010;
	char11[5 ] <= 160'h060003C00183FFF03FF806000020030000CFFFF8;
	char11[6 ] <= 160'h000003C001000000003006001FF0030008C00030;
	char11[7 ] <= 160'h000003C00200000004300600183003000E400030;
	char11[8 ] <= 160'h000003C00420000006310610183003000C000030;
	char11[9 ] <= 160'h000003C0083000000631FFF8183003180C000030;
	char11[10] <= 160'h000003C01070000004318618183FFFFC0C001830;
	char11[11] <= 160'h060003C00060001804318618183003000C1FFC30;
	char11[12] <= 160'h078003C000CFFFFC04318618183003000C181830;
	char11[13] <= 160'h070003C0018006000C218618183003000C181830;
	char11[14] <= 160'h07FFFFC0018006000C218618183203000C181830;
	char11[15] <= 160'h070003C003C006000C2186181FF103000C181830;
	char11[16] <= 160'h07000380068006000C29FFF81831C3000C1FF830;
	char11[17] <= 160'h070000000C8006001FFD86181830C3000C181830;
	char11[18] <= 160'h0700000018800600080946101830E3000C181830;
	char11[19] <= 160'h070000003080060000084600183043000C181830;
	char11[20] <= 160'h070000180080060000184600183003000C181830;
	char11[21] <= 160'h070000180080060000782400183003000C181830;
	char11[22] <= 160'h07000018008006000F983400183003000C1FF830;
	char11[23] <= 160'h070000380080060038181C001FF003000C181830;
	char11[24] <= 160'h070000380080060020101C00183003000C101030;
	char11[25] <= 160'h070000380080060000101E00183003000C000030;
	char11[26] <= 160'h0700003C0080060000303700180003000C000030;
	char11[27] <= 160'h07FFFFFC0081CE00033061C0000003000C000030;
	char11[28] <= 160'h03FFFFF800807C0001E180FE00003F000C0003F0;
	char11[29] <= 160'h0000000000801C0000E60038000007000C0000E0;
	char11[30] <= 160'h0000000001001000001800000000060008000040;
	char11[31] <= 160'h0000000000000000000000000000000000000000;
end 

always @ (posedge mclk)
begin 
	char12[0 ] <= 512'h00000000000000000000000003C006200C30181818181808300C300C300C300C300C300C300C300C300C300C1808181818180C30062003C00000000000000000;
	char12[1 ] <= 512'h000000000000000000000000008001801F800180018001800180018001800180018001800180018001800180018001800180018003C01FF80000000000000000;
	char12[2 ] <= 512'h00000000000000000000000007E008381018200C200C300C300C000C001800180030006000C0018003000200040408041004200C3FF83FF80000000000000000;
	char12[3 ] <= 512'h00000000000000000000000007C018603030301830183018001800180030006003C0007000180008000C000C300C300C30083018183007C00000000000000000;
	char12[4 ] <= 512'h0000000000000000000000000060006000E000E0016001600260046004600860086010603060206040607FFC0060006000600060006003FC0000000000000000;
	char12[5 ] <= 512'h0000000000000000000000000FFC0FFC10001000100010001000100013E0143018181008000C000C000C000C300C300C20182018183007C00000000000000000;
	char12[6 ] <= 512'h00000000000000000000000001E006180C180818180010001000300033E0363038183808300C300C300C300C300C180C18080C180E3003E00000000000000000;
	char12[7 ] <= 512'h0000000000000000000000001FFC1FFC100830102010202000200040004000400080008001000100010001000300030003000300030003000000000000000000;
	char12[8 ] <= 512'h00000000000000000000000007E00C301818300C300C300C380C38081E180F2007C018F030783038601C600C600C600C600C3018183007C00000000000000000;
	char12[9 ] <= 512'h00000000000000000000000007C01820301030186008600C600C600C600C600C701C302C186C0F8C000C0018001800103030306030C00F800000000000000000;
	char12[10] <= 512'h0000000000000000000000000000000000000000000000000000018003C003C001800000000000000000000000000000018003C003C001800000000000000000;
end


endmodule
