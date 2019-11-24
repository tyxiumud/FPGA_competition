`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/07 01:04:24
// Design Name: 
// Module Name: data_calculate
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
module data_calculate(
	input 					clk_50M			,
	input 					s_rst_n			,
	input  	 [15:0] 		data 			,
	output 					meter_1_en 		,
	output 					meter_0_5_en 	,
	output 	 	 			cm_20_en
    );	

reg meter_1;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		meter_1 <= 1'b0;
	else 
		if((data[15:8] <= 8'd0 && data[7:4] <= 4'd9 && data[3:0] <= 4'd9) && (data != 'd0))
			meter_1 <= 1'b1;
		else 
			if((data[15:8] >= 8'd1))
				meter_1 <= 1'b0;
			else 
				meter_1 <= meter_1;
end

reg [2:0] meter_1_delay;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		begin
			meter_1_delay <= 'd0;
		end
	else 
		begin
			meter_1_delay <= {meter_1_delay[1:0],meter_1};
		end
end 
//检测上升沿
wire pose_meter_1_en;
assign pose_meter_1_en = (~meter_1_delay[2])&&meter_1_delay[1];
assign meter_1_en = pose_meter_1_en;


reg meter_0_5;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		meter_0_5 <= 1'b0;
	else 
		if((data[15:8] <= 8'd0 && data[7:4] <= 4'd4 && data[3:0] <= 4'd9) && (data != 'd0))
			meter_0_5 <= 1'b1;
		else 
			if((data[15:8] >= 8'd1 || data[7:4] > 4'd5 && data[3:0] > 4'd0))
				meter_0_5 <= 1'b0;
			else 
				meter_0_5 <= meter_0_5;
end

reg [2:0] meter_0_5_delay;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		begin
			meter_0_5_delay <= 'd0;
		end
	else 
		begin
			meter_0_5_delay <= {meter_0_5_delay[1:0],meter_0_5};
		end
end 
//检测上升沿
wire pose_meter_0_5_en;
assign pose_meter_0_5_en = (~meter_0_5_delay[2])&&meter_0_5_delay[1];
assign meter_0_5_en = pose_meter_0_5_en;

reg cm_20;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		cm_20 <= 1'b0;
	else 
		if((data[15:8] <= 8'd0 && data[7:4] <= 4'd2 && data[3:0] <= 4'd0) && (data != 'd0))
			cm_20 <= 1'b1;
		else 
			if((data[15:8] >= 8'd1 || (data[7:4] > 4'd2 && data[3:0] > 4'd0)))
				cm_20 <= 1'b0;
			else 
				cm_20 <= cm_20;
end

reg [2:0] cm_20_delay;
always @ (posedge clk_50M or negedge s_rst_n)
begin
	if(!s_rst_n)
		begin
			cm_20_delay <= 'd0;
		end
	else 
		begin
			cm_20_delay <= {cm_20_delay[1:0],cm_20};
		end
end 
//检测上升沿
wire pose_cm_20_en;
assign pose_cm_20_en = (~cm_20_delay[2])&&cm_20_delay[1];
assign cm_20_en = pose_cm_20_en;


endmodule
