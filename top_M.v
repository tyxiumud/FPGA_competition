`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:56 11/03/2019 
// Design Name: 
// Module Name:    top_M 
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
module top_M(
	input 					s_clk		,
	input 					s_rst_n 	,
	output 					data_tx 	,
	input 		[3:0] 		data_sel 	,
	input 					data_sel_en 	
    );

reg [3:0] data_sel_r;
MUSIC MUSIC_0 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .select_music(data_sel_r), 
    .data_tx(data_tx)
    );


wire data_sel_en_dly;
reg [3:0] delay1;
assign data_sel_en_dly = delay1[3];
always @ (posedge s_clk or negedge s_rst_n)
begin
	if(!s_rst_n)
		delay1 <= 'd0;
	else 
		delay1 <= {delay1[2:0],data_sel_en};
end 

reg cnt_en;
reg [25:0] cnt ;
reg [2:0] cnt_time;
always@(posedge s_clk or negedge s_rst_n)    
begin  
    if(!s_rst_n)
	    cnt_en <= 1'b1;
	else 
	 	if(data_sel_en == 1'b1)
	    	cnt_en <= 1'b1;	
     	else
        	if(cnt_time == 'd5)	
        		cnt_en <= 'd0;
        	else 
        		cnt_en <= cnt_en;	 
end
always@(posedge s_clk or negedge s_rst_n)    
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
always@(posedge s_clk or negedge s_rst_n)    
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


always @ (posedge s_clk or negedge s_rst_n)
begin
	if(!s_rst_n)
		data_sel_r <= 'd0;
	else 
		if(data_sel_en_dly)
			data_sel_r <= data_sel;
		else 
			if(cnt_time == 'd5)	
				data_sel_r <= 'd0;
			else 	
				data_sel_r <= data_sel_r;
end




endmodule
