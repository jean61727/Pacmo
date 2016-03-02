module buzzer_control (
	input wire rst_n,
	input wire clk,
	input wire [15:0] audio_in_left,
	input wire [15:0] audio_in_right,
	output wire audio_APPSEL,
	output wire audio_SYSCLK,
	output wire audio_BCK,
	output wire audio_WS,
	output reg audio_DATA
);
	reg [6:0] clk_cnt;
	reg [6:0] clk_cnt_next;
	reg [15:0] audio_left;
	reg [15:0] audio_right;
	assign audio_APPSEL = 0;
	assign audio_SYSCLK = clk;
	assign audio_BCK = clk_cnt[0];
	assign audio_WS = clk_cnt[6];

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			clk_cnt = 7'd0;
			audio_left = 16'd0;
			audio_right = 16'd0;
		end
		else begin
			clk_cnt = clk_cnt_next;
			audio_left = audio_in_left;
			audio_right = audio_in_right;
		end
	end
	always @(*) begin
		if (clk_cnt == 7'b1111111)
			clk_cnt_next = 7'd0;
		else
			clk_cnt_next = clk_cnt + 1'b1;
	end
	always @(*) begin
		case (clk_cnt[6:2])
			5'b00000: audio_DATA = audio_right[15];
			5'b00001: audio_DATA = audio_right[14];
			5'b00010: audio_DATA = audio_right[13];
			5'b00011: audio_DATA = audio_right[12];
			5'b00100: audio_DATA = audio_right[11];
			5'b00101: audio_DATA = audio_right[10];
			5'b00110: audio_DATA = audio_right[9];
			5'b00111: audio_DATA = audio_right[8];
			5'b01000: audio_DATA = audio_right[7];
			5'b01001: audio_DATA = audio_right[6];
			5'b01010: audio_DATA = audio_right[5];
			5'b01011: audio_DATA = audio_right[4];
			5'b01100: audio_DATA = audio_right[3];
			5'b01101: audio_DATA = audio_right[2];
			5'b01110: audio_DATA = audio_right[1];
			5'b01111: audio_DATA = audio_right[0];
			5'b10000: audio_DATA = audio_left[15];
			5'b10001: audio_DATA = audio_left[14];
			5'b10010: audio_DATA = audio_left[13];
			5'b10011: audio_DATA = audio_left[12];
			5'b10100: audio_DATA = audio_left[11];
			5'b10101: audio_DATA = audio_left[10];
			5'b10110: audio_DATA = audio_left[9];
			5'b10111: audio_DATA = audio_left[8];
			5'b11000: audio_DATA = audio_left[7];
			5'b11001: audio_DATA = audio_left[6];
			5'b11010: audio_DATA = audio_left[5];
			5'b11011: audio_DATA = audio_left[4];
			5'b11100: audio_DATA = audio_left[3];
			5'b11101: audio_DATA = audio_left[2];
			5'b11110: audio_DATA = audio_left[1];
			5'b11111: audio_DATA = audio_left[0];

		endcase
	end

endmodule
