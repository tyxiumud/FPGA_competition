`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/05 14:08:01
// Design Name: 
// Module Name: vibrator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:使用的时钟为50MHz进行测试，这里尝试使用系统时钟
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module vibrator(
	input 			clk_50M 			,
	input 			s_rst_n	 		,
	input 			shake_open 		,
	input 			shake_close 	,
	output 	reg 	shake 			
    );
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		shake <= 1'b0;
	else 
		if(shake_open == 1'b1)
			shake <= 1'b1;
		else 
			if(shake_close == 1'b1)
				shake <= 1'b0;
			else 
				shake <= shake;
end
endmodule
