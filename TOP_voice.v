`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:49 11/06/2019 
// Design Name: 
// Module Name:    TOP_voice 
// Project Name: 孟国栋
// Target Devices: 
// Tool versions: 
// Description: 
//使用时直接将数据送入同时将使能信号拉高即可进行播放
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TOP_voice(
	input 					clk_50M			,
	input 					s_rst_n 		,
	output 					data_tx 		,
	input 		[3:0] 		select_voice 	,
	input 					select_voice_en 	
    );
reg [3:0] select_voice_r;
VOICE_v VOICE_0 (
    .clk 				(clk_50M 					), 
    .rst_n 				(s_rst_n 					), 
    .select_voice 		(select_voice_r 			), 
    .data_tx 			(data_tx 					)
    );


wire data_sel_en_dly;
reg [3:0] delay1;
assign data_sel_en_dly = delay1[3];
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		delay1 <= 'd0;
	else 
		delay1 <= {delay1[2:0],select_voice_en};
end 

reg cnt_en;
reg [25:0] cnt ;
reg [2:0] cnt_time;
always@(posedge clk_50M or negedge s_rst_n)    
begin  
    if(!s_rst_n)
	    cnt_en <= 1'b0;
	else 
	 	if(select_voice_en == 1'b1)
	    	cnt_en <= 1'b1;	
     	else
        	if(cnt_time == 'd5)	
        		cnt_en <= 'd0;
        	else 
        		cnt_en <= cnt_en;	 
end
always@(posedge clk_50M or negedge s_rst_n)    
begin  
    if(!s_rst_n)
	    cnt <= 0;
	else 
		if(cnt_en == 1'b1)
	 		begin
	 			if(cnt == 26'd24_999_999)
	    			cnt <= 0;	
     			else
        			cnt <= cnt + 1'b1;
	 		end		 
	 	else 
	 		cnt <= 'd0;
end
always@(posedge clk_50M or negedge s_rst_n)    
begin  
    if(!s_rst_n)
	    cnt_time <= 0;
	else 
	 	if(cnt_time == 'd5)
	    	cnt_time <= 0;	
     	else
     		if(cnt == 26'd24_999_999)
        		cnt_time <= cnt_time + 1'b1;
        	else 
        		cnt_time <= cnt_time;
end


always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		select_voice_r <= 'd0;
	else 
		if(data_sel_en_dly)
			select_voice_r <= select_voice;
		else 
			if(cnt_time == 'd5)	
				select_voice_r <= 'd0;
			else 	
				select_voice_r <= select_voice_r;
end




endmodule
