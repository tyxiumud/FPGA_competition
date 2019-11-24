`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/05 10:21:19
// Design Name: 
// Module Name: VGA_7670
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


module VGA_7670(
           input              clk         ,
		   input              rst_n         ,
		   
		   input	   [9:0]	x_cnt     ,
		   input	   [9:0]	y_cnt     ,
		   input				vidon     ,	
		                      
		   output [16:0]      addr        ,		   
		   output reg         ov_7670
		   
		   
		   
		   
    );
	
	reg spriteon;
	
	
	//assign addr = (y_cnt - 51) * 320 + (x_cnt - 189);
	assign addr = (y_cnt - 35) /2* 320 + (x_cnt - 143)/2;

	always@(*)
	begin
		 //if((y_cnt <= 290 ) && (y_cnt > 50) && (x_cnt <= 510) && (x_cnt > 190)) 
		 if((y_cnt <= 35 + 240*2 ) && (y_cnt > 35) && (x_cnt <= 144 + 320*2 ) && (x_cnt > 144)) 
		   spriteon = 1;
		 else
		   spriteon = 0; 
	end
	   	
	
	always@(*)
	begin			 
		    ov_7670 = 0;					 
		// if(vidon && spriteon)	
		if(vidon)
	        ov_7670 = 1;
		 else
			ov_7670 = 0;						
	end
	    
	
endmodule


