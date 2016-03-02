`timescale 1ns / 1ps
module top(clk, LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1, LCD_CS2, LCD_RST, LCD_DATA, col , row ,dig,seg,LED,pin,rst_n,
 audio_APPSEL,
 audio_SYSCLK,
 audio_BCK,
 audio_WS,
 audio_DATA
 
 );

	input  clk, rst_n;
	input [2:0] pin ;
	input  [0:3] col;
	output LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1, LCD_CS2, LCD_RST;
	output [7:0] LCD_DATA;
	output [0:3] row;
	output [0:3] dig;
	output [0:14] seg;
	output reg [2:0] LED;
	
	
	output wire audio_APPSEL;
	output wire audio_SYSCLK;
	output wire audio_BCK;
	output wire audio_WS;
	output wire audio_DATA;
	
	wire[4:0] ran_data;
	
	wire clk_100KHz, clk_1KHz,clk_100HZ;
	wire full = 0;
	wire lose = 0;
	reg [1:0] song = 1;
	wire [15:0] audio_in_left;
	wire [15:0] audio_in_right;
	wire [15:0] BCD ;
	wire [15:0] point;
	wire beat_clk ;
	wire HIT;
	wire push_0 ,push_1 ,push_4 ,push_7;
	wire[1:0] GENERATOR;
	wire reset_de , reset_go;
	reg start;
	
	always@(pin)begin
	
		if(pin[2] == 1)begin
			start = 1;
			LED[0] = 1;
		end
		else begin
			start = 0;
			LED[0] = 0;
		end
	
		if(pin[0] == 1)begin	
			song = 0;
			LED[2] = 1;
			LED[1] = 0;
		end
		else if (pin[1] == 1) begin
			song = 1;
			LED[2] = 0;
			LED[1] = 1;
		end
	end
	
	clk_div c1(.clock_40MHz(clk),.clock_100KHz(clk_100KHz),.clock_1KHz(clk_1KHz),.clock_100Hz(clk_100HZ));
	
	debounce d_ss(rst_n,clk_100HZ,reset_de);
	onepulse o_ss(reset_de, clk_100HZ, reset_go);
	
	
	note_generator n1(clk,rst_n&start ,beat_clk,full,lose,song,HIT,GENERATOR);
	
	assign audio_in_left = (beat_clk == 0) ? 16'h8000 : 16'h7FFF;
	assign audio_in_right = (beat_clk == 0) ? 16'h8000 : 16'h7FFF;/*do it outside because other module need its value*/
	
	buzzer_control b1(rst_n&start ,clk,audio_in_left,audio_in_right,audio_APPSEL,audio_SYSCLK,audio_BCK,audio_WS,audio_DATA);
	
	ran_counter rrr (clk_100KHz , ran_data);

	keypad_scanner key(clk_100HZ, rst_n&start , col, row ,push_0 ,push_1 ,push_4 ,push_7);
	PAC_MAN manman(clk_100KHz, (~reset_go)&start ,LCD_DATA , LCD_ENABLE, LCD_RW, LCD_RST, LCD_CS1, LCD_CS2, LCD_DI,
			push_0 ,push_1 ,push_4 ,push_7,HIT,point,GENERATOR,ran_data[1:0]);
			
	points count_point(clk_100KHz,(~reset_go)&start ,BCD,point);
	display_ct disp(clk_100KHz,BCD,dig, seg);
	
	
endmodule
