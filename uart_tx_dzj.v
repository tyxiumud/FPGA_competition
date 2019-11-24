`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:18:47 11/25/2018 
// Design Name: 
// Module Name:    uart_tx_dzj 
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
module uart_tx_dzj_z(
	input flag,
	input clk,
	input rst_n,
	input over_tx,
	
	output reg [7:0]data_rx,
	output send_en,
	output reg over_all
    );
	reg [25:0] cnt_1s;
	always@(posedge clk or negedge rst_n)     //这里需要有1s的延迟 再检测指纹
begin
	if(!rst_n)
	cnt_1s<=1'b0;
	else if(cnt_1s==26'd49_999_999)
	cnt_1s<=1'b0;
	else cnt_1s<=cnt_1s+1'b1;
end
	
	
	
	reg[3:0] cnt;                          	//最大要记到14   I like FPGA,too 一共14个字符
	always@(posedge clk or negedge rst_n)   //数每个字符结束 递 下一个字符的计数器
	begin
	if(!rst_n)begin
	 cnt<=1'b0;over_all<=1'b0;end
	else if(cnt==4'd12&cnt_1s==26'd49_999_999)
	 begin cnt<=1'b0; over_all<=1'b0;end
	 else if(over_tx)
	 cnt<=cnt+1'b1;
	else if(cnt==4'd11)
	 over_all<=1'b1; 
	/* else if(over_tx)
	 cnt<=cnt+1'b1;*/
	else begin cnt<=cnt; over_all<=over_all; end
	end 
	assign send_en=flag;
	
	always@(*)
	       begin
		   case(cnt)
		    4'd0:data_rx=8'hEF;  //EF      自动匹配  EF 01 FF FF FF FF 01 00 03 11 00 15
			4'd1:data_rx=8'h01;  //01 
			4'd2:data_rx=8'hFF;  //FF
			4'd3:data_rx=8'hFF;  //FF 
			4'd4:data_rx=8'hFF;  //FF
			4'd5:data_rx=8'hFF;  //FF  
			4'd6:data_rx=8'h01;  //01
			4'd7:data_rx=8'h00;  //00  
			4'd8:data_rx=8'h03;  //03 
			4'd9:data_rx=8'h11;  //11
			4'd10:data_rx=8'h00;  //00
			4'd11:data_rx=8'h15;  //15
			endcase
		   end
		   
endmodule