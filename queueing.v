`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:53 10/27/2019 
// Design Name: 
// Module Name:    queueing 
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
module queueing_v(
	input clk,							//系统时钟
	input rst_n,						//系统复位
	input in,							//总使能
	input [7:0] data1,data2,data3,data4,data5,data6,
										//指令划分的发送数据
	output reg [7:0] data_rx,           //UART发送数据
	output reg	EN						//有效使能
	);

reg [3:0]num;
reg [15:0] cnt;

always@(posedge clk)
begin
	if(!rst_n)	
		begin
		cnt <= 0;
		num <= 0;
		end
	else if(!in)	
		begin
		cnt <= 0;
		num <= 0;
		end
	else if(cnt == 16'd52084 - 1)
	begin
			cnt <= 4'b0;
			num <= num + 1;
			end
	else 
		begin
		cnt <= cnt + 1;
		num <= num;
		end
end

always@(posedge clk)
begin
	if(!rst_n)
		data_rx <= 0;
	else if(!in)
		data_rx <= 0;
	else
		begin
		case(num)
		4'd0 : data_rx <= data1;
		4'd1 : data_rx <= data2;
		4'd2 : data_rx <= data3;
		4'd3 : data_rx <= data4;
		4'd4 : data_rx <= data5;
		4'd5 : data_rx <= data6;
		default : data_rx <= 0;
		endcase
		end
end

always@(posedge	clk)
begin
	if(!in)	EN	<= 1'b0;
	else	if(cnt == 16'd52084 - 1)	EN <= 1'b1;
	else	EN <= 1'b0;
end

endmodule
