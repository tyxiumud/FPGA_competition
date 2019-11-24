`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/09 22:15:05
// Design Name: 
// Module Name: GONG_CHEN
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


module GONG_CHEN(
				      //--------------------------system
				input			        clk100Mhz		,
				input			        rst_n		,
				
				
					//-----------------------------7670摄像头
				input  		            OV7670_VSYNC  ,
	            input  		            OV7670_HREF   ,
	            input  		            OV7670_PCLK   ,
	            output 		            OV7670_XCLK   ,
	            output 		            OV7670_SIOC   ,
	            inout  		            OV7670_SIOD   ,
	            input   [7:0]           OV7670_D      ,	   	 	   
	            output                  PWDN          ,
	            output                  RESEST 		  ,
				
				     //-----------------------------VGA
				output	   		        hs             ,
				output	   		        vs             ,
				output	       [4:0]	vga_r          ,
				output	       [5:0]	vga_g          ,
				output	       [4:0]	vga_b          
				
				
				
    );
	

	
    
	
	
	wire clk_25;
	
	
	CLK_DIV clk_di
   (
    // Clock out ports
    .clk_out1(clk_25),     // output clk_out1
   // Clock in ports
    .clk_in1(clk100Mhz));
	
	VGA_TOP  VGA_DIS(
				      //--------------------------system
				.mclk		(clk_25		),
				.clk		(clk100Mhz		),
				.rst_n		(rst_n		),
			
				//-----------7670摄像头
				.OV7670_VSYNC (OV7670_VSYNC ),
	            .OV7670_HREF  (OV7670_HREF  ),
	            .OV7670_PCLK  (OV7670_PCLK  ),
	            .OV7670_XCLK  (OV7670_XCLK  ),
	            .OV7670_SIOC  (OV7670_SIOC  ),
	            .OV7670_SIOD  (OV7670_SIOD  ),
	            .OV7670_D     (OV7670_D     ),	   	 	   
	            .PWDN         (PWDN         ),
	            .RESEST 	  (RESEST 	    ),
				
				//------------VGA
				.hs           (hs           ),
				.vs           (vs           ),
				.vga_r        (vga_r        ),
				.vga_g        (vga_g        ),
				.vga_b        (vga_b        )

    );
	
	
	
	
		


	
endmodule
