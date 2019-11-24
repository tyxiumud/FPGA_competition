/*
* Title:    <话机屏幕显示>
* description:
* @author:  fateszs
* @data:    2018.7.06
*
*/
module lcd_12864(
	input	clk_50M, 
	input	rst,
//	input [511:0]data_buf,							//使用时去掉注释。
	output lcd_rs, 									//寄存器选择输出信号
	output lcd_rw, 										//读、写操作选择输出信号
	output lcd_e, 											
	output [7:0]lcd_data,
	input [1:0] flag
	); 							
	/*其余管脚：
					PSB接高电平		
					BLK接GND		
					BLA与接电位器以控制lcd背光亮度			
	*/
//*****************以下为其测试所用数据，使用时删除*****************/
	wire 	 [511:0]data_buf;
	assign data_buf[511:504] = 8'hC7;
	assign data_buf[503:496] = 8'hEB;		//请
	assign data_buf[495:488] = 8'hCA;
	assign data_buf[487:480] = 8'hB9;		//使
	assign data_buf[479:472] = 8'hD3;
	assign data_buf[471:464] = 8'hC3;		//用
	assign data_buf[463:456] = 8'hD6;
	assign data_buf[455:448] = 8'hB8;		//指
	assign data_buf[447:440] = 8'hCE;
	assign data_buf[439:432] = 8'hC6;		//纹
	assign data_buf[431:424] = 8'hBD;
	assign data_buf[423:416] = 8'hE2;		//解
	assign data_buf[415:408] = 8'hCB;
	assign data_buf[407:400] = 8'hF8;		//锁

	assign data_buf[399:392] = 8'hC6;
	assign data_buf[391:384] = 8'hA5;		//匹
	assign data_buf[383:376] = 8'hC5;
	assign data_buf[375:368] = 8'hE4;		//配
	assign data_buf[367:360] = 8'hCA;
	assign data_buf[359:352] = 8'hA7;		//失
	assign data_buf[351:344] = 8'hB0;
	assign data_buf[343:336] = 8'hDC;		//败
	assign data_buf[335:328] = 8'hB3;
	assign data_buf[327:320] = 8'hC9;		//成
	assign data_buf[319:312] = 8'hB9;
	assign data_buf[311:304] = 8'hA6;		//功

	assign data_buf[303:296] = 8'hBB;
	assign data_buf[295:288] = 8'hB6;		//欢
	assign data_buf[287:280] = 8'hD3;
	assign data_buf[279:272] = 8'hAD;		//迎
	assign data_buf[271:264] = 8'hCA;
	assign data_buf[263:256] = 8'hB9;		//使
	assign data_buf[255:248] = 8'hD3;
	assign data_buf[247:240] = 8'hC3;		//用
	assign data_buf[239:232] = 8'hC7;
	assign data_buf[231:224] = 8'hEB;		//请
	assign data_buf[223:216] = 8'hD6;
	assign data_buf[215:208] = 8'hD8;		//重
	assign data_buf[207:200] = 8'hCA;
	assign data_buf[199:192] = 8'hD4;		//试



//***************************************************************//
	 
/**************************产生lcd时钟信号*************************/

	reg clk_lcd; 										
	reg [16:0]cnt;    									              
	always @(posedge clk_50M or negedge rst)
	begin
		if (!rst)
		begin 
			cnt <= 17'b0;
			clk_lcd <= 0;
		end   
		else if(cnt == 17'd7999)				//时钟频率非常重要！！将近3k，经实测5k会在第0位出错。
		begin 
			cnt <= 17'd0;
			clk_lcd <= ~clk_lcd;
		end   
		else 
			cnt <= cnt +1'b1;
	end

	

//****************************lcd12806控制信号*****************************************/                           
	reg [8:0] state; //State Machine code
	parameter IDLE  			= 4'd0;             
	parameter CMD_WIDTH 		= 4'd1;             //设置数据接口数量
	parameter CMD_SET 		= 4'd2;					//选择指令集
	parameter CMD_CURSOR 	= 4'd3;             //设置光标
	parameter CMD_CLEAR 		= 4'd4;          	//清屏
	parameter CMD_ACCESS    = 4'd5;          	//输入方式设置：数据读写操作后，地址自动加一/画面不动
	parameter CMD_DDRAM     = 4'd6;          	//DDRAM行地址
	parameter DATA_WRITE		= 4'd7;             //数据写入
	parameter STOP 			= 4'd8;             //
	reg [5:0] cnt_time;
	reg [7:0] lcd_data_r;
	reg [7:0] data_buff;
	reg lcd_rs_r;
   //输出管教配置
	assign lcd_rs = lcd_rs_r;
	assign lcd_rw = 1'b0; 
	assign lcd_e  = clk_lcd; 									//与lcd时钟相同
	assign lcd_data = lcd_data_r;
	

	always @(posedge clk_lcd , negedge rst)
	begin
		if(!rst)
		begin
			lcd_rs_r <= 1'b0;
			state <= IDLE;
			lcd_data_r <= 8'bzzzzzzzz;							//高阻态
			cnt_time <= 6'd0;
		end
		else 
		begin
			case(state)
				IDLE:  
				begin  
					lcd_rs_r <= 1'b0;
					cnt_time <= 6'd0;
					state <= CMD_WIDTH;
					lcd_data_r <= 8'bzzzzzzzz;  
				end
				CMD_WIDTH:					
				begin
					lcd_rs_r <= 1'b0;
					state <= CMD_SET;	
					lcd_data_r <= 8'h30; 							//8位数据口
				end
				CMD_SET:
				begin
					lcd_rs_r <= 1'b0;
					state <= CMD_CURSOR;
					lcd_data_r <= 8'h30; 							//基本指令集
					//同一指令之动作不可同时改变 RE 及 DL ，需先改变 DL 后在改变 RE 才可确保 FLAG 正确设定
				end
				CMD_CURSOR:
				begin
					lcd_rs_r <= 1'b0;
					state <= CMD_CLEAR;
					lcd_data_r <= 8'h0c; 							// 关光标
				end
				CMD_CLEAR:
				begin
					lcd_rs_r <= 1'b0;
					state <= CMD_ACCESS;
					lcd_data_r <= 8'h01;							//清屏
				end
				CMD_ACCESS:
				begin
					lcd_rs_r <= 1'b0;
					state <= CMD_DDRAM;
					lcd_data_r <= 8'h06; 							//进入点设定
				end
				CMD_DDRAM:											//行数命令
				begin
					lcd_rs_r <= 1'b0;
					state <= DATA_WRITE;
					case (cnt_time)
						6'd0:		lcd_data_r <= 8'h80;
						6'd16:	lcd_data_r <= 8'h90;
						6'd32:	lcd_data_r <= 8'h88;
						6'd48:	lcd_data_r <= 8'h98;
					endcase
				end
				DATA_WRITE:												//写数据
				begin
					lcd_rs_r <= 1'b1;
					cnt_time <= cnt_time + 1'b1;
					lcd_data_r <= data_buff;
					case (cnt_time)
						6'd15:	state <= CMD_DDRAM;
						6'd31:	state <= CMD_DDRAM;
						6'd47:	state <= CMD_DDRAM;
						6'd63:	state <= STOP;
						default:	state <= DATA_WRITE;
					endcase
				end
				STOP:
				begin
					lcd_rs_r <= 1'b0;
					state <= CMD_DDRAM;
					lcd_data_r <= 8'h80;								//从第几行循环
					cnt_time <= 6'd0;
				end
				default: 
					state <= IDLE;
			endcase
		end
	end
	
	
	always @(cnt_time) 
	begin
		case (cnt_time)
			6'd0:  data_buff <= data_buf[511:504];
			6'd1:  data_buff <= data_buf[503:496]; 	//请
			6'd2:  data_buff <= data_buf[495:488];
			6'd3:  data_buff <= data_buf[487:480];  	//使
			6'd4:  data_buff <= data_buf[479:472]; 		 	
			6'd5:  data_buff <= data_buf[471:464]; 		 //用	
			6'd6:  data_buff <= data_buf[463:456];		
			6'd7:  data_buff <= data_buf[455:448];		//指	
			6'd8:  data_buff <= data_buf[447:440];		
			6'd9:  data_buff <= data_buf[439:432];		//	纹
			6'd10:  data_buff <=data_buf[431:424];		
			6'd11:  data_buff <=data_buf[423:416];		//解
			6'd12:  data_buff <=data_buf[415:408];		
			6'd13:  data_buff <=data_buf[407:400];		//锁
			6'd14:  data_buff <= 8'h20;
			6'd15:  data_buff <= 8'h20;
			
			6'd16:  data_buff <= 8'h20;
			6'd17:  data_buff <= 8'h20;
			6'd18:  data_buff <= 8'h20;//如果显示数字，需要加0'd48,例如data_buff <= num+8'd48
			6'd19:  data_buff <= 8'h20;
			6'd20:  data_buff <= "L";
			6'd21:  data_buff <= "O";
			6'd22:  data_buff <= "V";
			6'd23:  data_buff <= "E";
			6'd24:  data_buff <= " ";
			6'd25:  data_buff <= "Y";
			6'd26:  data_buff <= "O";
			6'd27:  data_buff <= "U";
			6'd28:  data_buff <= 8'h20;
			6'd29:  data_buff <= 8'h20;
			6'd30:  data_buff <= 8'h20;
			6'd31:  data_buff <= 8'h20;

			6'd32:  data_buff <= data_buf[399:392];
			6'd33:  data_buff <= data_buf[391:384];		//匹
			6'd34:  data_buff <= data_buf[383:376];
			6'd35:  data_buff <= data_buf[375:368];		//配
			6'd36:  
				if(flag == 2'b11)
				data_buff <= "i";
				else if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[367:360];  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[335:328];
				else 
				data_buff <= 8'h20;
			6'd37:
				if(flag == 2'b11)
				data_buff <= "n";
				else if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[359:352];  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[327:320];
				else 
				data_buff <= 8'h20;
			6'd38:
				if(flag == 2'b11)
				data_buff <= "g";
				else if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[351:344];  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[319:312];
				else 
				data_buff <= 8'h20;
			6'd39:
				if(flag == 2'b11)
				data_buff <= ".";
				else if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[343:336];  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[311:304];
				else 
				data_buff <= 8'h20;
			6'd40:
				if(flag == 2'b11)
				data_buff <= ".";
				else if(flag == 2'b01) 		//识别失败
				data_buff <= 8'h20;  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= 8'h20;
				else 
				data_buff <= 8'h20;
			6'd41:
				if(flag == 2'b11)
				data_buff <= ".";
				else if(flag == 2'b01) 		//识别失败
				data_buff <= 8'h20;  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= 8'h20;
				else 
				data_buff <= 8'h20;
			6'd42:  data_buff <= 8'h20;
			6'd43:  data_buff <= 8'h20;
			6'd44:  data_buff <= 8'h20;
			6'd45:  data_buff <= 8'h20;
			6'd46:  data_buff <= 8'h20;
			6'd47:  data_buff <= 8'h20;
	
			6'd48: 
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[239:232];  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[303:296];
				else 
					data_buff <= 8'h20;
			6'd49: 
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[231:224];  		//请
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[295:288]; 		//欢
				else 
					data_buff <= 8'h20;
			6'd50:  
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[223:216] ;  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[287:280];
				else 
					data_buff <= 8'h20;
			6'd51: 
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[215:208];  		//重
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[279:272];   		//迎
				else 
					data_buff <= 8'h20;                                    
			6'd52: 
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[207:200];  		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[271:264];
				else 
					data_buff <= 8'h20;
			6'd53:  
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buf[199:192];  		//试
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[263:256];
				else 
					data_buff <= 8'h20;
			6'd54:
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buff <= "!"; 		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[255:248];
				else 
					data_buff <= 8'h20;
			6'd55: 
				if(flag == 2'b01) 		//识别失败
				data_buff <= data_buff <= "!";		
				else if(flag == 2'b10) 		//识别成功
				data_buff <= data_buf[247:240];
				else 
					data_buff <= 8'h20;
			6'd56:
				if(flag == 2'b10) 		//识别成功
				data_buff <= "!";
				else 
					data_buff <= 8'h20;
			6'd57:
				if(flag == 2'b10) 		//识别成功
				data_buff <= "!";
				else 
					data_buff <= 8'h20;
			6'd58: 
				if(flag == 2'b10) 		//识别成功
				data_buff <= "!";
				else 
					data_buff <= 8'h20;
			6'd59:  data_buff <= 8'h20;
			6'd60:  data_buff <= 8'h20;
			6'd61:  data_buff <= 8'h20;
			6'd62:  data_buff <= 8'h20;
			6'd63:  data_buff <= 8'h20;
 
			default :  data_buff <= 8'h02;
		endcase
	end
endmodule 


