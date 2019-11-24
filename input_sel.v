`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:17:16 10/27/2019 
// Design Name: 
// Module Name:    input_sel 
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
module input_sel_v(
	input clk,								//系统时钟
	input rst_n,							//系统复位
	input [3:0]select,						//发送选择
	output reg s1,s2,s3,s4,s5,s6,s7,s8,s9,
											//曲目选择:select[0-10]
	output reg f0,f1,f2,f3,f4,f5
											//功能选择:select[11-15]
    );
	 
	 
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
		begin
		s1 <= 0;
		s2 <= 0;
		s3 <= 0;
		s4 <= 0;
		s5 <= 0;
		s6 <= 0;
		s7 <= 0;
		s8 <= 0;
		s9 <= 0;
		f0 <= 0;
		f1 <= 0;
		f2 <= 0;
		f3 <= 0;
		f4 <= 0;
		f5 <= 0;
		end
	 else case(select)
	 4'd1 : begin
				s1 <= 1;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd2 : begin
				s1 <= 0;
				s2 <= 1;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd3 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 1;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd4 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 1;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd5 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 1;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd6 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 1;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd7 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 1;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd8 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 1;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd9 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 1;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd10 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 1;//jixu
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd11 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 1;//zanting
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd12 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 1;//+
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd13 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 1;//-
				f4 <= 0;
				f5 <= 0;
			  end
	 4'd14 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 1;//下一曲//000000000
				f5 <= 0;
			  end
	 4'd15 : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 1;//上一曲
			  end
	 default : begin
				s1 <= 0;
				s2 <= 0;
				s3 <= 0;
				s4 <= 0;
				s5 <= 0;
				s6 <= 0;
				s7 <= 0;
				s8 <= 0;
				s9 <= 0;
				f0 <= 0;
				f1 <= 0;
				f2 <= 0;
				f3 <= 0;
				f4 <= 0;
				f5 <= 0;
			  end
	 endcase
	 


endmodule
