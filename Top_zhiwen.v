`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:15:17 10/22/2019 
// Design Name: 
// Module Name:    Top_zhiwen 
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
module Top_zhiwen(
	input 			clk 				,
	input 			rst_n 				,
	input 			chumo 				,
	input 			data_rx 			, 	
	output 			RX232 				,
	output [1:0] 	flag 				, //识别失败是flag[1] 为识别失败
    output 			lcd_rs 				, //寄存器选择输出信号
    output 			lcd_rw 				,     //读、写操作选择输出信号
    output 			lcd_e 				,                                           
    output [7:0] 	lcd_data 			
    );
Top_uart_tx_z a (
    .flag(tx_en), 
    .clk(clk), 
    .rst_n(rst_n), 
    .RX232(RX232), 
    .over_rx(over_rx), 
    .over_all(over_all)
    );
zhiwen_z ab (
	.zhongzhi(zhongzhi),
    .chumo(chumo), 
	.over_all(over_all),
    .tx_en(tx_en)
    );
top_uart_rx_z abc (
    .clk(clk), 
    .rst_n(rst_n), 
    .data_rx(data_rx),
    .flag(flag)
    );
assign zhongzhi = flag[0];

lcd_12864 lcd_12864_0(
    .clk_50M               (clk     ), 
    .rst                   (rst_n   ),
    .lcd_rs                (lcd_rs  ),                                  //寄存器选择输出信号
    .lcd_rw                (lcd_rw  ),                                      //读、写操作选择输出信号
    .lcd_e                 (lcd_e   ),                                           
    .lcd_data              (lcd_data),
    .flag                  (~flag    )    
    );

endmodule
