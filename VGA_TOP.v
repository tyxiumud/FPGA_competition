`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/18 17:36:23
// Design Name: 
// Module Name: VGA_TOP
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


module VGA_TOP(
				     
				input   clk,
				input mclk,
				input rst_n,
					//-----------------------------7670摄像头
				input  OV7670_VSYNC ,
	            input  	OV7670_HREF ,
	            input  	OV7670_PCLK ,
	            output 	 OV7670_XCLK ,
	            output 	OV7670_SIOC ,
	            inout  OV7670_SIOD ,
	            input   [7:0] OV7670_D  ,	   	 	   
	            output   PWDN          ,
	            output    RESEST 		 ,
				input 	CAM_en 			,
				     //-----------------------------VGA
				output    hs ,
				output    vs ,
				output 	 [4:0]vga_r,
				output 	 [5:0]vga_g,
				output 	 [4:0]vga_b,

				//input or output singnals to display module 
				input 		[15:0]		rgb  		,
				output 		[9:0]		x_cnt		,
				output 		[9:0]		y_cnt		,
				output 					vidon 		,
				output 		[15:0]		doutb_ram  		

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
	//---------------------------------------------------7670摄像头
	wire [15:0]       doutb_ram ; 
	wire [16:0] addra;
	wire [16:0] addrb;
	wire [15:0] dina;
	wire posdge;
	reg  vidon;
	
	assign PWDN = 1'b0;
	assign RESEST = 1'b1;
	assign OV7670_XCLK  = mclk;

	
	
	
	//-------------------------------------------- -----------------------------------------------640*480 分辨率产生
	reg [9:0]x_cnt;  //行列计数器
	reg [9:0]y_cnt;
	
	always@(posedge mclk or negedge rst_n)   //横坐标计数
	begin
	     if(!rst_n)
		    x_cnt <= 10'd1;
         else if(x_cnt == 10'd800)
            x_cnt <= 10'd1;
         else 
            x_cnt <= x_cnt +1;
    end

    always@(posedge mclk or negedge rst_n)   //纵坐标计数
	begin
	     if(!rst_n)
		    y_cnt <= 10'd1;
		 else if(x_cnt == 10'd800) begin    //在一个横坐标记满的前提下进行纵坐标计数
		       if(y_cnt == 10'd525)
			       y_cnt <= 10'd1;
			   else
			       y_cnt <= y_cnt +1;
		 end
	end

assign hs = (x_cnt < Hor_Sync) ? 1'b1 : 1'b0;
assign vs = (y_cnt < Ver_Sync) ? 1'b1 : 1'b0;	

	

always@(*)
begin
	vidon <= (x_cnt >= (Hor_Sync + Hor_Back_Porch) && x_cnt <= (Hor_Sync + Hor_Back_Porch + Hor_Addr_Time) && 
		y_cnt >= (Ver_Sync + Ver_Back_Porch) && y_cnt <= (Ver_Sync + Ver_Back_Porch + Ver_Addr_Time));
end
	

//wire  [15:0] rgb;
assign {vga_r,vga_g,vga_b} = rgb;


	//////////////////////////////////////////////////////////////////////////顶层例化
	wire po;
	
	RAM_reg1 U4(                   //--------------7670RAM
	       .addra(addra),
		   .clka(posdge),
		   .dina(dina),
		   .wea(1'b1),
		   .addrb(addrb),
		   .clkb(mclk),
		   .doutb(doutb_ram)
	);
	
	
	
	IIC U1(
           .iCLK	    (mclk),
	       .iRST_N	    (rst_n),
		   .I2C_SCLK   (OV7670_SIOC),
	       .I2C_SDAT   (OV7670_SIOD),
	       .I2C_RDATA  (),
		   .LUT_INDEX  (),
           .Config_Done ()
    );
	
	capture U2(
        .clk(clk),
		.OV7670_PCLK(OV7670_PCLK),
		.rst_n(rst_n),
        .vsync(OV7670_VSYNC),
        .href(OV7670_HREF),
        .d(OV7670_D),
        .addr(addra),
        .dout(dina),
		.posdge(posdge),
		.po(po)
    );
	
	VGA_7670 U3(                                
	       .clk      (mclk),                       
		   .rst_n    (rst_n), 
		   .x_cnt    (x_cnt) ,
		   .y_cnt    (y_cnt) ,
		   .vidon    (vidon) ,	
		   .ov_7670  (ov_7670),
	       .addr     (addrb)                      
                                                
    );                                          
	      
	
	
	
	
	
endmodule
