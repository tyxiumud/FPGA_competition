`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/05 10:20:36
// Design Name: 
// Module Name: capture
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


module capture(
        input clk,
		input rst_n,
		input OV7670_PCLK,
input vsync,
input href,
input[7:0] d,
output[15:0] addr,
output reg[15:0] dout,
output posdge,
output reg po

    );
	
    reg [15:0] d_latch;
    reg [15:0] address;
    reg [15:0] address_next;  
     reg [1:0] wr_hold;     
reg  s1_uart_data_rx;
reg  s2_uart_data_rx;
reg tmp_a_uart_data_rx;
reg tmp_b_uart_data_rx;   

assign addr = address;

// 亚稳态消隥ͳ：对外部输入的异步信号进行同步处理
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		s1_uart_data_rx<=1'b0;
		s2_uart_data_rx<=1'b0;
		end
	else
		begin
		s1_uart_data_rx<=OV7670_PCLK;
		s2_uart_data_rx<=s1_uart_data_rx;
		end
	end
	//边沿检测（判断按键是否按下或释放）
	//使用D触发器存储两个相邻时钟上升沿时外部输入信号（已经同步到系统时钟域中）的电平状怍
	always@(posedge clk or negedge rst_n)
	begin
	if(!rst_n)
		begin
		tmp_a_uart_data_rx<=1'b0;
		tmp_b_uart_data_rx<=1'b0;
		end
	else
		begin
		tmp_a_uart_data_rx<=s1_uart_data_rx;
		tmp_b_uart_data_rx<=tmp_a_uart_data_rx;
		end
	end
	
	//产生跳变沿信反
	assign posdge=(!tmp_b_uart_data_rx)&tmp_a_uart_data_rx;   //下降沿检浍


always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
	    d_latch = 16'b0;
        address = 15'b0;
        address_next = 19'b0;
        wr_hold = 2'b0;  
		po<=0;
	end
    else if(posdge)
	begin
        if( vsync ==1) 
	    begin
           address <=15'b0;
           address_next <= 15'b0;
           wr_hold <=  2'b0;
        end
        else 
		begin
            if(address<60000)
                address <= address_next;
            else
                address <= 60000;
            wr_hold <= {wr_hold[0] , (href &&( ! wr_hold[0])) };
            d_latch <= {d_latch[7:0] , d};
            if (wr_hold[1] ==1 )
			begin
			    po<=1;
                address_next <=address_next+1;
                dout[15:0]  <= {d_latch[15:11] , d_latch[10:5] , d_latch[4:0] };
            end
        end;
    end
	else
	begin
	    po<=0;
	end
 end

endmodule

