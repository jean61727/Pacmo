`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:04 03/24/2015 
// Design Name: 
// Module Name:    display_ct 
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
module display_ct(clk, bcds, dig, seg);
	input clk;
	input [15:0] bcds;
	output reg [0:3] dig;
	output reg [0:14] seg;	// abcd efg1g2 hjklmnp
	parameter BCD0 = 15'b0000_0011_1100111,
	BCD1 = 15'b1001_1111_1111111,
	BCD2 = 15'b0010_0100_1111111,
	BCD3 = 15'b0000_1100_1111111,
 	BCD4 = 15'b1001_1000_1111111,
	BCD5 = 15'b0100_1000_1111111,
	BCD6 = 15'b0100_0000_1111111,
	BCD7 = 15'b0001_1111_1111111,
	BCD8 = 15'b0000_0000_1111111,
	BCD9 = 15'b0000_1000_1111111,
	BCDA = 15'b0001_0000_1111111,
	BCDB = 15'b0000_1110_1011011,
	BCDC = 15'b0110_0011_1111111,
	BCDD = 15'b0000_1111_1011011,
	BCDE = 15'b0110_0000_1111111,
	BCDF = 15'b0111_0000_1111111,	
	DARK = 15'b1111_1111_1111111;
	
	reg[0:1] tmp;
	reg[3:0] play;
	
	always@(posedge clk) begin
		if(tmp == 2'b00)
			begin 
				dig = 4'b0111;
				play = bcds[15:12];
			end
		else if(tmp == 2'b01)
			begin 
				dig = 4'b1011;
				play = bcds[11:8];
			end
		else if(tmp == 2'b10)
			begin 
				dig = 4'b1101;
				play = bcds[7:4];
			end
		else if(tmp == 2'b11)
			begin 
				dig = 4'b1110;
				play = bcds[3:0];
			end
		else tmp = 2'b00 ;
		
		tmp = tmp + 1'b1;
	end
	
	always@(play) begin
		case(play)
			4'b0000: seg = BCD0;
			4'b0001: seg = BCD1;
			4'b0010: seg = BCD2;
			4'b0011: seg = BCD3;
			4'b0100: seg = BCD4;
			4'b0101: seg = BCD5;
			4'b0110: seg = BCD6;
			4'b0111: seg = BCD7;
			4'b1000: seg = BCD8;
			4'b1001: seg = BCD9;
			4'b1010: seg = BCDA;
			4'b1011: seg = BCDB;
			4'b1100: seg = BCDC;
			4'b1101: seg = BCDD;
			4'b1110: seg = BCDE;
			4'b1111: seg = BCDF;
			default: seg = DARK;
		endcase
	end

endmodule
