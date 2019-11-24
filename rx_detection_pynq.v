`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/07 00:23:22
// Design Name: 
// Module Name: rx_detection_pynq
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


module rx_detection_pynq(
	clk,rst_n,po_data,po_flag,
    data_1_en,data_2_en
    );
input clk;
input rst_n;
input [7:0] po_data;
input po_flag;
output reg data_1_en		;
output reg data_2_en		;


always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			data_1_en    <= 1'b0;
			data_2_en    <= 1'b0;		
		end	
	else 
		if(po_flag)
				begin
					case(po_data)
					"1"	:	data_1_en 	<= 1'b1		;
					"2"	:	data_2_en 	<= 1'b1		;
					default:;
					endcase
				end
		else 
			begin
				data_1_en    <= 1'b0;
				data_2_en    <= 1'b0;
			end	
end
endmodule
