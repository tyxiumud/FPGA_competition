`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:21 10/27/2019 
// Design Name: 
// Module Name:    select 
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
module select_v(
	input clk,							//系统时钟
	input rst_n,						//系统复位
	output reg in,						//总使能
	input s1,s2,s3,s4,s5,s6,s7,s8,s9,
										//曲目选择:select[0-10]
	input f0,f1,f2,f3,f4,f5,
										//功能选择:select[11-15]
	output reg [47:0] data				//输出发送数据
    );
	 
	reg sel;
	reg [22:0] Voicnt;
	reg [19:0] cnt;
	reg en;
	
always@(posedge clk)
begin
	if(!rst_n)
	begin
		sel <= 0;
		Voicnt <= 0;
	end
	else if(!in)
	begin
		sel <= 0;
		Voicnt <= 0;
	end
	else if(Voicnt == 23'd500000)
	begin
		sel <= 1;
		Voicnt <= Voicnt + 1;
	end
	else if(Voicnt == 23'd500001)
	begin
		sel <= 0;
		Voicnt <= Voicnt;
	end
	else
	begin
			sel <= 0;
			Voicnt <= Voicnt + 1;
		  end
end

always@(posedge clk)
begin
	if(!rst_n)
		en <= 0;
	else if(!in)
		en <= 0;
	else if(sel)
		begin
		cnt <= 0;
		en <= 1;
		end
	else if(cnt == 20'd1000000)
		begin
		en <= 0;
		cnt <= 0;
		end
	else
		cnt <= cnt + 1;
end


always@(posedge clk) 
begin
	if(!rst_n)
		begin
		in <= 0;
		data <= 48'h000000000000;
		end
	else if(s1)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_01EF;//播放曲目一
		else
		data <= 48'h000000000000;
		end
	else if(s2)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_02EF;//播放曲目二
		else
		data <= 48'h000000000000; 
		end
	else if(s3)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_03EF;//播放曲目三
		else
		data <= 48'h000000000000;
		end
	else if(s4)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_04EF;//播放曲目四
		else
		data <= 48'h000000000000;
		end
	else if(s5)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_05EF;//播放曲目五
		else
		data <= 48'h000000000000;
		end
	else if(s6)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_06EF;//播放曲目六
		else
		data <= 48'h000000000000;
		end
	else if(s7)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_07EF;//播放曲目七
		else
		data <= 48'h000000000000;
		end
	else if(s8)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_08EF;//播放曲目八
		else
		data <= 48'h000000000000;
		end
	else if(s9)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_09EF;//播放曲目九
		else
		data <= 48'h000000000000;
		end
	else if(f0)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E02_01EF_0000;//继续
		else
		data <= 48'h000000000000;
		end
	else if(f1)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_00EF;//暂停
		else
		data <= 48'h000000000000;
		end
	else if(f2)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E0205EF0000;//音量+
		else
		data <= 48'h000000000000;
		end
	else if(f3)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E0206EF0000;//音量-
		else
		data <= 48'h000000000000;
		end
	else if(f4)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E04_4500_00EF;//下一曲//0000000
		else
		data <= 48'h000000000000;
		end
	else if(f5)
		begin
		in <= 1;
		if(en)
		data <= 48'h7E0204EF0000;//上一曲
		else
		data <= 48'h000000000000;
		end
	else
		begin
		in <= 0;
		data <= 48'h000000000000;
		end
	
	
	
end




endmodule
