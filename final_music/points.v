`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:12:41 06/12/2015 
// Design Name: 
// Module Name:    points 
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
module points(display_clk, RST_N,BCD,point);

input  display_clk;
input [15:0] point;
input RST_N;
output reg [15:0]BCD = 0;
reg Zero_point =0;
reg [3:0] bcd1_NEXT=0;
reg [3:0] bcd2_NEXT =0;
reg [3:0] bcd3_NEXT =0;
reg [3:0] bcd4_NEXT=0;
reg [3:0] bcd1=0;
reg [3:0] bcd2=0;
reg [3:0] bcd3=0;
reg [3:0] bcd4=0;


	always@(*)begin

		bcd1=bcd1_NEXT;
		bcd2=bcd2_NEXT ;
		bcd3=bcd3_NEXT;
		bcd4=bcd4_NEXT;
		
		BCD = {bcd4,bcd3,bcd2,bcd1};
	
	end 
	
	always@(posedge display_clk or negedge RST_N)begin
	
		if(!RST_N)begin
			bcd1_NEXT = 0;
			bcd2_NEXT = 0;
			bcd3_NEXT = 0;
			bcd4_NEXT = 0;
			Zero_point =0;
		end
		else begin
			if(point < 4'd10)begin 
				Zero_point =0;
				bcd1_NEXT = point;
			end
			else begin 
				if (Zero_point==0)begin
					bcd1_NEXT = 0;
					Zero_point =1;
					if(bcd2 == 4'd9)begin
						bcd2_NEXT = 0;
						if(bcd3 == 4'd9)begin
							bcd3_NEXT = 0;
							bcd4_NEXT = bcd4 + 1;
						end
						else bcd3_NEXT = bcd3 + 1;
					end else bcd2_NEXT = bcd2 + 1;
				end
			end
		end

		
	end


















endmodule
