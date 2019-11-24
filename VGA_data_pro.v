`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/20 11:50:29
// Design Name: 
// Module Name: VGA_data_pro
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


module VGA_data_pro(
	input 				clk_50M 		,
	input 				s_rst_n 		,
	//time
	output 	 	[32:0] 	time_pass_data 	,
	input 		[32:0]	time_now_data 	,
	//music
	input 				music_dis_open	,
	input 				music_dis_close ,
	output 	reg			music_state 	,
	//疲劳
	input 				pilao_en 		,
	output 				pilao_dis_open 	,
	//为了调试，时间加1
	input 				plus_shi 		,
	output 				display_3_en 	,
	output 				display_4_en	
    );
//time
reg clk_1s;//分频后的时钟
reg [25:0] cnt;
always@(posedge clk_50M or negedge s_rst_n)    
begin  
   if(!s_rst_n)
	    cnt <= 0;
	else if(cnt==26'd24_999_999)//当cnt为24_999_999的时候，重新计数并且将clk1反转
	begin
	    cnt <= 0;	
	    clk_1s <= ~clk_1s;
    end
    else
       cnt <= cnt + 1'b1;		 
end
reg [7:0] miao_data;
always @ (posedge clk_1s or negedge s_rst_n)
begin
	if(!s_rst_n)
		miao_data <= 'd0;
	else 
		if(miao_data[3:0] == 'd9 && miao_data[7:4] == 'd5)
			miao_data <= 'd0;
		else 
			if(miao_data[3:0] == 'd9)
				begin
					miao_data[3:0] <= 'd0;
					miao_data[7:4] <= miao_data[7:4] + 1'b1;
				end
			else 
				miao_data <= miao_data + 1'b1;
end
reg [7:0] fen_data;
always @ (posedge clk_1s or negedge s_rst_n)
begin
	if(!s_rst_n)
		fen_data <= 'd0;
	else 
		if(fen_data[3:0] == 'd9 && fen_data[7:4] == 'd5)
			fen_data <= 'd0;
		else 
			if(fen_data[3:0] == 'd9)
				begin
					fen_data[3:0] <= 'd0;
					fen_data[7:4] <= fen_data[7:4] + 1'b1;
				end
			else 
				if(miao_data[3:0] == 'd9 && miao_data[7:4] == 'd5)
					fen_data <= fen_data + 1'b1;
end
reg [7:0] shi_data;
always @ (posedge clk_1s or negedge s_rst_n)
begin
	if(!s_rst_n)
		shi_data <= 'd0;
	else 
		if(shi_data[3:0] == 'd3 && shi_data[7:4] == 'd2)
			shi_data <= 'd0;
		else 
			if(shi_data[3:0] == 'd9)
				begin
					shi_data[3:0] <= 'd0;
					shi_data[7:4] <= shi_data[7:4] + 1'b1;
				end
			else 
				if(fen_data[3:0] == 'd9 && fen_data[7:4] == 'd5)
					shi_data <= shi_data + 1'b1;
				else 
					if(plus_shi == 1'b1)
						shi_data <= 'd6;
end
assign time_pass_data = {shi_data,fen_data,miao_data};
reg display_3 ;
reg display_4 ;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		begin
			display_3 <= 1'b0;
			display_4 <= 1'b0;
		end
	else 
		if(time_now_data[23:16] >= 'd8 && shi_data >= 'd5 )
			display_3 <= 1'b1;
		else 
			if((time_now_data[23:16] < 'd8 || time_now_data[23:20] >= 2) && shi_data >= 'd2)
				display_4 <= 1'b1;
			else 
				begin
					display_3 <= 1'b0;
					display_4 <= 1'b0;
				end

end
reg [2:0] display_3_delay;
always @ (posedge clk_50M or negedge s_rst_n)
begin
if(!s_rst_n)
	begin
		display_3_delay <= 'd0;
	end
else 
	begin
		display_3_delay <= {display_3_delay[1:0],display_3};
	end
end 
//检测上升沿下降沿
wire nege_display_3;
wire pose_display_3;
assign pose_display_3 = (~display_3_delay[2])&&display_3_delay[1];
assign nege_display_3 = display_3_delay[2]&&(!display_3_delay[1]);
reg [2:0] display_4_delay;
always @ (posedge clk_50M or negedge s_rst_n)
begin
if(!s_rst_n)
	begin
		display_4_delay <= 'd0;
	end
else 
	begin
		display_4_delay <= {display_4_delay[1:0],display_4};
	end
end 
//检测上升沿下降沿
wire nege_display_4;
wire pose_display_4;
assign pose_display_4 = (~display_4_delay[2])&&display_4_delay[1];
assign nege_display_4 = display_4_delay[2]&&(!display_4_delay[1]);
assign display_3_en = pose_display_3;//5小时
assign display_4_en = pose_display_4;//2小时

//疲劳显示
reg [25:0] cnt_pilao;
reg cnt_pilao_en;
assign pilao_dis_open = cnt_pilao_en;
reg [4:0] cnt_pilao_time;
always@(posedge clk_50M or negedge s_rst_n)    
begin
	if(!s_rst_n)
		cnt_pilao_en <= 1'b0;
	else 
		if(pilao_en)
			cnt_pilao_en <= 1'b1;
		else 
			if(cnt_pilao_time == 'd20)
				cnt_pilao_en <= 1'b0;
end

always@(posedge clk_50M or negedge s_rst_n)    
begin  
   if(!s_rst_n)
	    cnt_pilao <= 0;
	else 
		if(cnt_pilao_en)
			begin
				if(cnt_pilao==26'd24_999_999)
	    			cnt_pilao <= 0;	
    			else
    			   cnt_pilao <= cnt_pilao + 1'b1;		 	
			end		
		else 
			 cnt_pilao <= 'd0;
end

always@(posedge clk_50M or negedge s_rst_n)    
begin  
  if(!s_rst_n)
  	cnt_pilao_time <= 'd0;
  else 
  	if(cnt_pilao==26'd24_999_999)
  		cnt_pilao_time <= cnt_pilao_time + 1'b1;
  	else 
  		if(cnt_pilao_time == 'd20)
  			cnt_pilao_time <= 'd0;
end 

//音乐
always@(posedge clk_50M or negedge s_rst_n)    
begin  
  if(!s_rst_n)
  	music_state <= 1'b0;
  else 
  	if(music_dis_open)
  		music_state <= 1'b1;
  	else 
  		if(music_dis_close)
	  		music_state <= 1'b0;
	  	else 
	  		music_state <= music_state;
end

endmodule
