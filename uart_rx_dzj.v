`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:36 11/25/2018 
// Design Name: 
// Module Name:    uart_rx_dzj 
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
module uart_rx_dzj_z(
	input clk,
	input rst_n,
	input [7:0]data_tx,
	input over_rx,
	input nedge,
	//input over_all,
	output reg [1:0]flag
    );
	parameter s0=4'd0,s1=4'd1,s2=4'd2,s3=4'd3,s4=4'd4,s5=4'd5,s6=4'd6,s7=4'd7,s8=4'd8,s9=4'd9,s10=4'd10,s11=4'd12;
	reg[3:0] present_state,next_state;
	always@(posedge clk or negedge rst_n)
	begin
	  if(!rst_n)
		begin
	    present_state<=s0;
		end
	  else if(~over_rx&nedge) present_state<=next_state;
	end
	
	always@(*)
	 begin
	 case(present_state)
	    s0: if(data_tx==8'hEF/*8'b01001001*/)  //EF             
			  next_state<=s1;
			else next_state<=s0;
		s1: if(data_tx==8'h01)  //01
			  next_state<=s2;
			else next_state<=s0;
		s2: if(data_tx==8'hFF)  //FF
			  next_state<=s3;
			else next_state<=s0;
		s3: if(data_tx==8'hFF)  //FF
			  next_state<=s4;
			else next_state<=s0;
		s4: if(data_tx==8'hFF)  //FF
			  next_state<=s5;
			else next_state<=s0;
		s5: if(data_tx==8'hFF)  //FF 
			  next_state<=s6;
			else next_state<=s0;
		s6: if(data_tx==8'h07)  //07
			  next_state<=s7;
			else next_state<=s0;
		s7: if(data_tx==8'h00)  //00
			  next_state<=s8;
			else next_state<=s0;
		s8: if(data_tx==8'h07)  //07
			  next_state<=s9;
			else next_state<=s0;
		s9: begin 
			case(data_tx)
			 8'h00: next_state<=s10;
			 8'h09: next_state<=s11;
			 default: next_state<=s0;
			endcase
			/*if(data_tx==8'h00)  //         00有指纹匹配成功  09有指纹匹配失败
			  next_state<=s10;
			if(data_tx==8'h09)
			  next_state<=s11;
			else next_state<=s0;*/
			end
		default: next_state<=s0;
	 endcase
	 end 
	always@(posedge clk or negedge rst_n)
	 begin
		if(!rst_n)
			flag<=2'b00;
		else if(next_state==s10)
			flag<=2'b01;
		else if(next_state==s11)
			flag<=2'b10;
	 end
endmodule
