`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:54:00 11/08/2019 
// Design Name: 
// Module Name:    top_distance 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_distance(
	input 					clk_50M			,
	input 					s_rst_n			,
	output 					meter_1_en 		,
	output 					meter_0_5_en 	,
	output 					cm_20_en 		,
	input 					Echo 			,
	output 	 	 			trig 		    ,
    input                   Echo1           ,
    output                  trig1           ,
    output     [15:0]       data        
    );
wire [15:0] data0;
wire [15:0] data1;

measurement measurement_0 (
    .clk_50M(clk_50M), 
    .s_rst_n(s_rst_n), 
    .Echo(Echo), 
    .trig(trig), 
    .data(data0)
    );

measurement measurement_1 (
    .clk_50M(clk_50M), 
    .s_rst_n(s_rst_n), 
    .Echo(Echo1), 
    .trig(trig1), 
    .data(data1)
    );
assign data = (data0+data1)/2;
data_calculate data_calculate_0 (
    .clk_50M(clk_50M), 
    .s_rst_n(s_rst_n), 
    .data(data), 
    .meter_1_en(meter_1_en), 
    .meter_0_5_en(meter_0_5_en), 
    .cm_20_en(cm_20_en)
    );

endmodule
