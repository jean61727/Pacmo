	module note_generator (clk,rst_n,beat_clk,full,lose,song,HIT,GENERATOR);

	input wire clk;
	input wire rst_n;
	input full;
	input lose;
	input [1:0]song ;
	output reg beat_clk;
	output reg HIT;
	//output[1:0] out_GENERATOR;
	reg [9:0] tone = 10'h3FA;
	reg [9:0] tone_next;
	reg [19:0] freq_div;
	reg beat_clk_next;
	reg [19:0] divide, divide_next;
	reg [23:0] counter, counter_next;
	output reg [1:0] GENERATOR;
	//reg [1:0] valid , valid_next;
	
	
	//assign out_GENERATOR = {GENERATOR[1] & valid[1] , GENERATOR[0] & valid[0]}  ;
	
	parameter 
	LMI = 20'd121212,
	LFA = 20'd114285,
	LSO = 20'd102040,
	LSO_LA = 20'd96475,
	LLA = 20'd90909,
	LSI = 20'd80971,
	DO = 20'd76336,
	DO_RE = 20'd71942,
	RE = 20'd68027,
	MI = 20'd60606,
	FA = 20'd57306,
	FA_SO = 20'd53908,
	SO = 20'd51020,
	LA = 20'd45455,
	SI = 20'd40486,
	HDO = 20'd38240,
	HRE = 20'd34071,
	HMI = 20'd30349,
	HFA = 20'd28612,
	HSO = 20'd25510,
	ZERO = 20'd0;
	
	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			divide = 0;
			beat_clk = 0;
			tone = 10'h3FA;
			counter = 0;
			
		end 
		else if(full==1'b1||lose==1'b1) tone = DO;/*遊戲有結果的時候 停止音樂輸出*/
		else begin
			divide = divide_next;
			beat_clk = beat_clk_next;
			tone = tone_next;
			counter = counter_next;
			
		end
	end
	
	
	always @(*) begin
		if (counter != ( 24'hDF_FFFF))begin
			counter_next = counter + 1'd1; 
			tone_next = tone;		
			
		end
		else begin
			counter_next = 24'd0;
			
			if (tone == 10'h1B7 && song == 0) begin
				tone_next = 10'h3FA;
			end
			else if(tone == 10'h0FF && song == 1)begin
				tone_next = 10'h3FA;
			end
			else begin	
				tone_next = tone + 1'd1;
			end
			
		end
		//delay_next = delay + 1;
	end
	
	
	always @(*) begin
		if (counter == ( 24'hDF_FFFF))begin
			beat_clk_next = ~beat_clk;
			divide_next = 0;
		end
		else if (divide == (freq_div - 1'b1)) begin/*use the defined fre_div to achieve the finction of note generator*/
			divide_next = 0;
			 
			beat_clk_next = ~beat_clk;
			 
		end
		else begin
			divide_next = divide + 1'b1;
			beat_clk_next = beat_clk;
		end
	end

	always @(*) begin
		case (song)
		2'b00:   /*  blurry eyes   */
			case (tone)
			/*intro*/
			10'h000: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;end
			10'h001: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;end
			10'h002: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;end
			10'h003: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;end
			10'h004: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;end
			10'h005: begin freq_div = RE;HIT = 0 ; GENERATOR = 2;end
			10'h006: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;end
			10'h007: begin freq_div = RE; HIT = 0 ; GENERATOR = 0; end
			10'h008: begin freq_div = DO_RE;HIT = 1 ; GENERATOR = 0; end
			10'h009: begin freq_div = DO_RE; HIT = 0 ;  GENERATOR = 0; end
			10'h00A: begin freq_div = DO_RE; HIT = 0 ; GENERATOR = 0;  end
			10'h00B: begin freq_div = DO_RE; HIT = 0 ; GENERATOR = 0;  end
			10'h00C: begin freq_div = DO_RE; HIT = 0 ; GENERATOR = 0;  end
			10'h00D: begin freq_div = DO_RE; HIT = 0 ; GENERATOR = 3;  end
			10'h00E: begin freq_div = DO_RE; HIT = 0 ; GENERATOR = 0;  end
			10'h00F: begin freq_div = DO_RE; HIT = 0 ; GENERATOR = 0;  end
			10'h010: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 0;  end
			10'h011: begin freq_div =  LSI; HIT = 0 ; GENERATOR = 0;  end
			10'h012: begin freq_div = LSI; HIT = 0 ; GENERATOR = 0;  end
			10'h013: begin freq_div = LSI; HIT = 0 ; GENERATOR = 0;  end
			10'h014: begin freq_div = LSI ; HIT = 0 ; GENERATOR = 0;  end
			10'h015: begin freq_div = LSI; HIT = 0 ; GENERATOR = 2;  end
			10'h016: begin freq_div =  LSI; HIT = 0 ; GENERATOR = 1;  end
			10'h017: begin freq_div = LSI; HIT = 0 ;  GENERATOR = 2; end
			10'h018: begin freq_div = DO; HIT = 1 ; GENERATOR = 0; end
			10'h019: begin freq_div = MI; HIT = 1 ; GENERATOR = 2; end
			10'h01A: begin freq_div = MI; HIT = 1 ; GENERATOR = 0; end
			10'h01B: begin freq_div = MI; HIT = 0 ; GENERATOR = 2; end
			10'h01C: begin freq_div = HDO; HIT = 1 ; GENERATOR = 1; end
			10'h01D: begin freq_div = HDO; HIT = 0 ; GENERATOR = 0; end
			10'h01E: begin freq_div = MI; HIT = 1 ; GENERATOR = 0; end
			10'h01F: begin freq_div = LA; HIT = 1 ; GENERATOR = 0; end
			
			10'h020: begin freq_div = SO; HIT = 1 ; GENERATOR = 0; end
			10'h021: begin freq_div = SO; HIT = 0 ; GENERATOR = 0; end
			10'h022: begin freq_div = SO; HIT = 0 ; GENERATOR = 0; end
			10'h023: begin freq_div = SO; HIT = 0 ; GENERATOR = 0; end
			10'h024: begin freq_div = SO; HIT = 0 ; GENERATOR = 0; end
			10'h025: begin freq_div =SO; HIT = 0 ; GENERATOR = 2; end
			10'h026: begin freq_div = SO; HIT = 0 ; GENERATOR = 0; end
			10'h027: begin freq_div = SO; HIT = 0 ; GENERATOR = 0; end
			10'h028: begin freq_div = FA_SO;HIT = 1 ; GENERATOR = 0; end
			10'h029: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 0; end
			10'h02A: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 0; end
			10'h02B: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 0; end
			10'h02C: begin freq_div = FA_SO; HIT = 0 ;GENERATOR = 0;  end
			10'h02D: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 2; end
			10'h02E: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 0; end
			10'h02F: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 0; end
			10'h030: begin freq_div = MI;  HIT = 1 ; GENERATOR = 0; end
			10'h031: begin freq_div =  MI; HIT = 0 ; GENERATOR = 2; end
			10'h032: begin freq_div = MI;  HIT = 0 ; GENERATOR = 1; end
			10'h033: begin freq_div = MI;  HIT = 0 ; GENERATOR = 2; end
			10'h034: begin freq_div =  FA; HIT = 1 ; GENERATOR = 1; end
			10'h035: begin freq_div = HDO; HIT = 1 ; GENERATOR = 2; end
			10'h036: begin freq_div =  FA; HIT = 1 ; GENERATOR = 2; end
			10'h037: begin freq_div = MI;  HIT = 1 ; GENERATOR = 1; end
			10'h038: begin freq_div = SO;  HIT = 1 ; GENERATOR = 0; end
			10'h039: begin freq_div = SO;  HIT = 1 ; GENERATOR = 2; end
			10'h03A: begin freq_div = SO; HIT = 1 ; GENERATOR = 0; end
			10'h03B: begin freq_div = SO; HIT = 0 ; GENERATOR = 1; end
			10'h03C: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 1; end
			10'h03D: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 0; end
			10'h03E: begin freq_div = MI;  HIT = 1 ; GENERATOR = 2; end
			10'h03F: begin freq_div = RE; HIT = 1 ; GENERATOR = 1; end
			
			/*Pre*/
			10'h040: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h041: begin freq_div = DO_RE;  HIT = 1 ;GENERATOR = 0;  end
			10'h042: begin freq_div = RE;  HIT = 1 ; GENERATOR = 2; end
			10'h043: begin freq_div = MI;  HIT = 1 ; GENERATOR = 1; end
			10'h044: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h045: begin freq_div = RE; HIT = 1 ;GENERATOR = 0;  end
			10'h046: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 1; end
			10'h047: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 2; end
			10'h048: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h049: begin freq_div = LLA;  HIT = 1 ; GENERATOR = 0; end
			10'h04A: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 1; end
			10'h04B: begin freq_div = MI;  HIT = 1 ; GENERATOR = 1; end
			10'h04C: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h04D: begin freq_div = RE; HIT = 1 ; GENERATOR = 0; end
			10'h04E: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 1; end
			10'h04F: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 1; end
			10'h050: begin freq_div = ZERO;	 HIT = 0 ; GENERATOR = 2; end
			10'h051: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 1; end
			10'h052: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 0; end
			10'h053: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 0; end
			10'h054: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 2; end
			10'h055: begin freq_div = LSI;	HIT = 0 ; GENERATOR = 1; end
			10'h056: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h057: begin freq_div = LSI ; 	HIT = 1 ; GENERATOR = 0; end
			10'h058: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 1; end
			10'h059: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 0; end
			10'h05A: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 1; end
			10'h05B: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 1; end
			10'h05C: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 2; end
			10'h05D: begin freq_div = LSI;	 HIT = 1 ; GENERATOR = 0; end
			10'h05E: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 1; end
			10'h05F: begin freq_div = SO ;	 HIT = 1 ; GENERATOR = 1; end
			
			10'h060: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h061: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 0; end
			10'h062: begin freq_div = SO;  	HIT = 1 ; GENERATOR = 2; end
			10'h063: begin freq_div = LA;  	HIT = 1 ; GENERATOR = 1; end
			10'h064: begin freq_div = ZERO;  HIT = 0 ;GENERATOR = 1;  end
			10'h065: begin freq_div = SO; 	HIT = 1 ; GENERATOR = 0; end
			10'h066: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 1; end
			10'h067: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 2; end
			10'h068: begin freq_div = ZERO;	HIT = 0 ; GENERATOR = 1; end
			10'h069: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 0; end
			10'h06A: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 2; end
			10'h06B: begin freq_div = LA; 	HIT = 1 ; GENERATOR = 1; end
			10'h06C: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h06D: begin freq_div = SO;	   HIT = 1 ;GENERATOR = 0;  end
			10'h06E: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 1; end
			10'h06F: begin freq_div = MI;		HIT = 1 ; GENERATOR = 2; end
			10'h070: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h071: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 0; end
			10'h072: begin freq_div = LLA; 	HIT = 1 ; GENERATOR = 2; end
			10'h073: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 0; end
			10'h074: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h075: begin freq_div = MI;		HIT = 1 ; GENERATOR = 0; end
			10'h076: begin freq_div = LLA; 	HIT = 0 ; GENERATOR = 2; end
			10'h077: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 1; end
			10'h078: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h079: begin freq_div = MI;		 HIT = 1 ; GENERATOR = 0; end
			10'h07A: begin freq_div = LLA;  HIT = 1 ; GENERATOR = 1; end
			10'h07B: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 1; end
			10'h07C: begin freq_div = LLA; 	HIT = 0 ; GENERATOR = 2; end
			10'h07D: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 0; end
			10'h07E: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 0; end
			10'h07F: begin freq_div = RE;  	HIT = 1 ; GENERATOR = 0; end
			
			/*Pre 2*/
			10'h080: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h081: begin freq_div = DO_RE;  HIT = 1 ;GENERATOR = 0;  end
			10'h082: begin freq_div = RE;  HIT = 1 ; GENERATOR = 2; end
			10'h083: begin freq_div = MI;  HIT = 1 ; GENERATOR = 1; end
			10'h084: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h085: begin freq_div = RE; HIT = 1 ;GENERATOR = 0;  end
			10'h086: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 1; end
			10'h087: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 2; end
			10'h088: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h089: begin freq_div = LLA;  HIT = 1 ; GENERATOR = 0; end
			10'h08A: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 1; end
			10'h08B: begin freq_div = MI;  HIT = 1 ; GENERATOR = 1; end
			10'h08C: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h08D: begin freq_div = RE; HIT = 1 ; GENERATOR = 0; end
			10'h08E: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 1; end
			10'h08F: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 1; end
			10'h090: begin freq_div = ZERO;	 HIT = 0 ; GENERATOR = 2; end
			10'h091: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 1; end
			10'h092: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 0; end
			10'h093: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 0; end
			10'h094: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 2; end
			10'h095: begin freq_div = LSI;	HIT = 0 ; GENERATOR = 1; end
			10'h096: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h097: begin freq_div = LSI ; 	HIT = 1 ; GENERATOR = 0; end
			10'h098: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 1; end
			10'h099: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 0; end
			10'h09A: begin freq_div = FA_SO; HIT = 0 ; GENERATOR = 1; end
			10'h09B: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 1; end
			10'h09C: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 2; end
			10'h09D: begin freq_div = LSI;	 HIT = 1 ; GENERATOR = 0; end
			10'h09E: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 1; end
			10'h09F: begin freq_div = SO ;	 HIT = 1 ; GENERATOR = 1; end
			
			10'h0A0: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 1; end
			10'h0A1: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 0; end
			10'h0A2: begin freq_div = SO;  	HIT = 1 ; GENERATOR = 2; end
			10'h0A3: begin freq_div = LA;  	HIT = 1 ; GENERATOR = 1; end
			10'h0A4: begin freq_div = ZERO;  HIT = 0 ;GENERATOR = 1;  end
			10'h0A5: begin freq_div = SO; 	HIT = 1 ; GENERATOR = 0; end
			10'h0A6: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 1; end
			10'h0A7: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 2; end
			10'h0A8: begin freq_div = ZERO;	HIT = 0 ; GENERATOR = 1; end
			10'h0A9: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 0; end
			10'h0AA: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 2; end
			10'h0AB: begin freq_div = LA; 	HIT = 1 ; GENERATOR = 1; end
			10'h0AC: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h0AD: begin freq_div = SO;	   HIT = 1 ;GENERATOR = 0;  end
			10'h0AE: begin freq_div = FA_SO; HIT = 1 ; GENERATOR = 1; end
			10'h0AF: begin freq_div = MI;		HIT = 1 ; GENERATOR = 2; end
			10'h0B0: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h0B1: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 0; end
			10'h0B2: begin freq_div = LA; 	HIT = 1 ; GENERATOR = 1; end
			10'h0B3: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 2; end
			10'h0B4: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h0B5: begin freq_div = MI;		HIT = 1 ; GENERATOR = 0; end
			10'h0B6: begin freq_div = LA; 	HIT = 1 ; GENERATOR = 1; end
			10'h0B7: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 2; end
			10'h0B8: begin freq_div = ZERO;  HIT = 0 ; GENERATOR = 2; end
			10'h0B9: begin freq_div = MI;		 HIT = 1 ; GENERATOR = 1; end
			10'h0BA: begin freq_div = SO;  HIT = 1 ; GENERATOR = 1; end
			10'h0BB: begin freq_div = SO; 	HIT = 1 ; GENERATOR = 1; end
			10'h0BC: begin freq_div = FA_SO; 	HIT = 1 ; GENERATOR = 1; end
			10'h0BD: begin freq_div = FA_SO; 	HIT = 1 ; GENERATOR = 2; end
			10'h0BE: begin freq_div = MI;  HIT = 1 ; GENERATOR = 0; end
			10'h0BF: begin freq_div = MI;  	HIT = 1 ; GENERATOR = 1; end
			
			/* VERSE */
			
			10'h0C0: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 2; end
			10'h0C1: begin freq_div = RE;  	HIT = 0 ;GENERATOR = 0;  end
			10'h0C2: begin freq_div = RE; 	 HIT = 1 ; GENERATOR = 1; end
			10'h0C3: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 2; end
			10'h0C4: begin freq_div = FA_SO;  HIT = 0 ; GENERATOR = 0; end
			10'h0C5: begin freq_div = FA_SO; HIT = 1 ;GENERATOR = 2;  end
			10'h0C6: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 0; end
			10'h0C7: begin freq_div = RE; 	HIT = 0 ; GENERATOR = 1; end
			10'h0C8: begin freq_div = LLA; 	HIT = 1 ; GENERATOR = 2; end
			10'h0C9: begin freq_div = LLA;  	HIT = 0 ; GENERATOR = 0; end
			10'h0CA: begin freq_div = LLA; 	 HIT = 1 ; GENERATOR = 2; end
			10'h0CB: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 1; end
			10'h0CC: begin freq_div = DO_RE;  HIT = 0 ; GENERATOR = 0; end
			10'h0CD: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 1; end
			10'h0CE: begin freq_div = LLA;  	HIT = 1 ; GENERATOR = 0; end
			10'h0CF: begin freq_div = LLA; 	HIT = 0 ; GENERATOR = 1; end
			10'h0D0: begin freq_div = LSI;	 HIT = 1 ; GENERATOR = 2; end
			10'h0D1: begin freq_div = LSI; 	HIT = 0 ; GENERATOR = 0; end
			10'h0D2: begin freq_div = LSI;   HIT = 1 ; GENERATOR = 2; end
			10'h0D3: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 1; end
			10'h0D4: begin freq_div = RE; HIT = 0 ; GENERATOR = 0; end
			10'h0D5: begin freq_div = RE;	HIT = 1 ; GENERATOR = 1; end
			10'h0D6: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 0; end
			10'h0D7: begin freq_div = LSI ; 	HIT = 0 ; GENERATOR = 1; end
			10'h0D8: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 2; end
			10'h0D9: begin freq_div = LSI; 	HIT = 0 ; GENERATOR = 0; end
			10'h0DA: begin freq_div = LSI; HIT = 1 ; GENERATOR = 1; end
			10'h0DB: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 2; end
			10'h0DC: begin freq_div = RE; HIT = 0 ; GENERATOR = 0; end
			10'h0DD: begin freq_div = MI;	 HIT = 1 ; GENERATOR = 1; end
			10'h0DE: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 0; end
			10'h0DF: begin freq_div = FA_SO ;	 HIT = 0 ; GENERATOR = 1; end
			
			10'h0E0: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 2; end
			10'h0E1: begin freq_div = LSO;  	HIT = 0 ;GENERATOR = 0;  end
			10'h0E2: begin freq_div = LSO; 	 HIT = 1 ; GENERATOR = 1; end
			10'h0E3: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 2; end
			10'h0E4: begin freq_div = LSI;  HIT = 0 ; GENERATOR = 0; end
			10'h0E5: begin freq_div = LSI; HIT = 1 ;GENERATOR = 2;  end
			10'h0E6: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 0; end
			10'h0E7: begin freq_div = LSO; 	HIT = 0 ; GENERATOR = 1; end
			10'h0E8: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 2; end
			10'h0E9: begin freq_div = LSO;  	HIT = 0 ; GENERATOR = 0; end
			10'h0EA: begin freq_div = LSO; 	 HIT = 1 ; GENERATOR = 2; end
			10'h0EB: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 1; end
			10'h0EC: begin freq_div = LSI;  HIT = 0 ; GENERATOR = 0; end
			10'h0ED: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 1; end
			10'h0EE: begin freq_div = RE;  	HIT = 1 ; GENERATOR = 0; end
			10'h0EF: begin freq_div = RE; 	HIT = 0 ; GENERATOR = 1; end
			10'h0F0: begin freq_div = LLA;	 HIT = 1 ; GENERATOR = 2; end
			10'h0F1: begin freq_div = LLA; 	HIT = 0 ; GENERATOR = 0; end
			10'h0F2: begin freq_div = LLA;   HIT = 1 ; GENERATOR = 2; end
			10'h0F3: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 1; end
			10'h0F4: begin freq_div = MI; HIT = 0 ; GENERATOR = 0; end
			10'h0F5: begin freq_div = MI;	HIT = 1 ; GENERATOR = 1; end
			10'h0F6: begin freq_div = RE;  HIT = 1 ; GENERATOR = 1; end
			10'h0F7: begin freq_div = RE ; 	HIT = 0 ; GENERATOR = 0; end
			10'h0F8: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 2; end
			10'h0F9: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 0; end
			10'h0FA: begin freq_div = MI; HIT = 0 ; GENERATOR = 1; end
			10'h0FB: begin freq_div = DO_RE; 	HIT = 1 ; GENERATOR = 2; end
			10'h0FC: begin freq_div = DO_RE; HIT = 0 ; GENERATOR = 0; end
			10'h0FD: begin freq_div = DO_RE;	 HIT = 1 ; GENERATOR = 1; end
			10'h0FE: begin freq_div = LLA;  HIT = 1 ; GENERATOR = 0; end
			10'h0FF: begin freq_div = LLA ;	 HIT = 0 ; GENERATOR = 1; end

			10'h100: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 2; end
			10'h101: begin freq_div = RE;  	HIT = 0 ;GENERATOR = 0;  end
			10'h102: begin freq_div = RE; 	 HIT = 1 ; GENERATOR = 1; end
			10'h103: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 2; end
			10'h104: begin freq_div = FA_SO;  HIT = 0 ; GENERATOR = 0; end
			10'h105: begin freq_div = FA_SO; HIT = 1 ;GENERATOR = 2;  end
			10'h106: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 0; end
			10'h107: begin freq_div = RE; 	HIT = 0 ; GENERATOR = 1; end
			10'h108: begin freq_div = LLA; 	HIT = 1 ; GENERATOR = 2; end
			10'h109: begin freq_div = LLA;  	HIT = 0 ; GENERATOR = 0; end
			10'h10A: begin freq_div = LLA; 	 HIT = 1 ; GENERATOR = 2; end
			10'h10B: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 1; end
			10'h10C: begin freq_div = DO_RE;  HIT = 0 ; GENERATOR = 0; end
			10'h10D: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 1; end
			10'h10E: begin freq_div = LLA;  	HIT = 1 ; GENERATOR = 0; end
			10'h10F: begin freq_div = LLA; 	HIT = 0 ; GENERATOR = 1; end
			10'h110: begin freq_div = LSI;	 HIT = 1 ; GENERATOR = 2; end
			10'h111: begin freq_div = LSI; 	HIT = 0 ; GENERATOR = 0; end
			10'h112: begin freq_div = LSI;   HIT = 1 ; GENERATOR = 2; end
			10'h113: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 1; end
			10'h114: begin freq_div = RE; HIT = 0 ; GENERATOR = 0; end
			10'h115: begin freq_div = RE;	HIT = 1 ; GENERATOR = 1; end
			10'h116: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 0; end
			10'h117: begin freq_div = LSI ; 	HIT = 0 ; GENERATOR = 1; end
			10'h118: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 2; end
			10'h119: begin freq_div = LSI; 	HIT = 0 ; GENERATOR = 0; end
			10'h11A: begin freq_div = LSI; HIT = 1 ; GENERATOR = 1; end
			10'h11B: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 2; end
			10'h11C: begin freq_div = RE; HIT = 0 ; GENERATOR = 0; end
			10'h11D: begin freq_div = MI;	 HIT = 1 ; GENERATOR = 1; end
			10'h11E: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 0; end
			10'h11F: begin freq_div = FA_SO ;	 HIT = 0 ; GENERATOR = 1; end
			
			10'h120: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 2; end
			10'h121: begin freq_div = LSO;  	HIT = 0 ;GENERATOR = 0;  end
			10'h122: begin freq_div = LSO; 	 HIT = 1 ; GENERATOR = 1; end
			10'h123: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 2; end
			10'h124: begin freq_div = LSI;  HIT = 0 ; GENERATOR = 0; end
			10'h125: begin freq_div = LSI; HIT = 1 ;GENERATOR = 2;  end
			10'h126: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 0; end
			10'h127: begin freq_div = LSO; 	HIT = 0 ; GENERATOR = 1; end
			10'h128: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 2; end
			10'h129: begin freq_div = LSO;  	HIT = 0 ; GENERATOR = 0; end
			10'h12A: begin freq_div = LSO; 	 HIT = 1 ; GENERATOR = 2; end
			10'h12B: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 1; end
			10'h12C: begin freq_div = LSI;  HIT = 0 ; GENERATOR = 0; end
			10'h12D: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 1; end
			10'h12E: begin freq_div = RE;  	HIT = 1 ; GENERATOR = 2; end
			10'h12F: begin freq_div = RE; 	HIT = 0 ; GENERATOR = 0; end
			10'h130: begin freq_div = LA;	 HIT = 1 ; GENERATOR = 1; end
			10'h131: begin freq_div = SO; 	HIT = 1 ; GENERATOR = 2; end
			10'h132: begin freq_div = SO;   HIT = 0 ; GENERATOR = 1; end
			10'h133: begin freq_div = FA_SO; 	HIT = 1 ; GENERATOR = 0; end
			10'h134: begin freq_div = SO; HIT = 1 ; GENERATOR = 1; end
			10'h135: begin freq_div = FA_SO;	HIT = 1 ; GENERATOR = 2; end
			10'h136: begin freq_div = FA_SO;  HIT = 0 ; GENERATOR = 1; end
			10'h137: begin freq_div = MI ; 	HIT = 1 ; GENERATOR = 0; end
			10'h138: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR =1; end
			10'h139: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 2; end
			10'h13A: begin freq_div = MI; HIT = 0 ; GENERATOR = 1; end
			10'h13B: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 0; end
			10'h13C: begin freq_div = MI; HIT = 1 ; GENERATOR = 2; end
			10'h13D: begin freq_div = RE;	 HIT = 1 ; GENERATOR = 0; end
			10'h13E: begin freq_div = RE;  HIT = 0 ; GENERATOR = 0; end
			10'h13F: begin freq_div = DO_RE ; HIT = 1 ; GENERATOR = 0; end
			
			/* 副歌 */
			
			10'h140: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 2; end
			10'h141: begin freq_div = RE;  	HIT = 0 ;GENERATOR = 0;  end
			10'h142: begin freq_div = RE; 	 HIT = 1 ; GENERATOR = 1; end
			10'h143: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 2; end
			10'h144: begin freq_div = FA_SO;  HIT = 0 ; GENERATOR = 0; end
			10'h145: begin freq_div = FA_SO; HIT = 1 ;GENERATOR = 2;  end
			10'h146: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 0; end
			10'h147: begin freq_div = RE; 	HIT = 0 ; GENERATOR = 1; end
			10'h148: begin freq_div = LLA; 	HIT = 1 ; GENERATOR = 2; end
			10'h149: begin freq_div = LLA;  	HIT = 0 ; GENERATOR = 0; end
			10'h14A: begin freq_div = LLA; 	 HIT = 1 ; GENERATOR = 2; end
			10'h14B: begin freq_div = DO_RE;  HIT = 1 ; GENERATOR = 1; end
			10'h14C: begin freq_div = DO_RE;  HIT = 0 ; GENERATOR = 0; end
			10'h14D: begin freq_div = DO_RE; HIT = 1 ; GENERATOR = 1; end
			10'h14E: begin freq_div = LLA;  	HIT = 1 ; GENERATOR = 0; end
			10'h14F: begin freq_div = LLA; 	HIT = 0 ; GENERATOR = 1; end
			10'h150: begin freq_div = LSI;	 HIT = 1 ; GENERATOR = 2; end
			10'h151: begin freq_div = LSI; 	HIT = 0 ; GENERATOR = 0; end
			10'h152: begin freq_div = LSI;   HIT = 1 ; GENERATOR = 2; end
			10'h153: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 1; end
			10'h154: begin freq_div = RE; HIT = 0 ; GENERATOR = 0; end
			10'h155: begin freq_div = RE;	HIT = 1 ; GENERATOR = 1; end
			10'h156: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 0; end
			10'h157: begin freq_div = LSI ; 	HIT = 0 ; GENERATOR = 1; end
			10'h158: begin freq_div = LSI;  HIT = 1 ; GENERATOR = 2; end
			10'h159: begin freq_div = LSI; 	HIT = 0 ; GENERATOR = 0; end
			10'h15A: begin freq_div = LSI; HIT = 1 ; GENERATOR = 1; end
			10'h15B: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 2; end
			10'h15C: begin freq_div = RE; HIT = 0 ; GENERATOR = 0; end
			10'h15D: begin freq_div = MI;	 HIT = 1 ; GENERATOR = 1; end
			10'h15E: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 0; end
			10'h15F: begin freq_div = FA_SO ;	 HIT = 0 ; GENERATOR = 1; end
			
			10'h160: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 2; end
			10'h161: begin freq_div = LSO;  	HIT = 0 ;GENERATOR = 0;  end
			10'h162: begin freq_div = LSO; 	 HIT = 1 ; GENERATOR = 1; end
			10'h163: begin freq_div = RE;  HIT = 1 ; GENERATOR = 2; end
			10'h164: begin freq_div = RE;  HIT = 0 ; GENERATOR = 0; end
			10'h165: begin freq_div = RE; HIT = 1 ;GENERATOR = 2;  end
			10'h166: begin freq_div = LSO; 	HIT = 1 ; GENERATOR = 0; end
			10'h167: begin freq_div = LSO; 	HIT = 0 ; GENERATOR = 1; end
			10'h168: begin freq_div = LSO_LA; 	HIT = 1 ; GENERATOR = 2; end
			10'h169: begin freq_div = LSO_LA;  	HIT = 0 ; GENERATOR = 0; end
			10'h16A: begin freq_div = LSO_LA; 	 HIT = 1 ; GENERATOR = 2; end
			10'h16B: begin freq_div = RE;  HIT = 1 ; GENERATOR = 1; end
			10'h16C: begin freq_div = RE;  HIT = 0 ; GENERATOR = 0; end
			10'h16D: begin freq_div = RE; HIT = 1 ; GENERATOR = 1; end
			10'h16E: begin freq_div = LSO_LA;  	HIT = 1 ; GENERATOR = 0; end
			10'h16F: begin freq_div = LSO_LA; 	HIT = 0 ; GENERATOR = 1; end
			10'h170: begin freq_div = LLA;	 HIT = 1 ; GENERATOR = 2; end
			10'h171: begin freq_div = LLA; 	HIT = 0 ; GENERATOR = 0; end
			10'h172: begin freq_div = LLA;   HIT = 1 ; GENERATOR = 2; end
			10'h173: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 2; end
			10'h174: begin freq_div = MI; HIT = 0 ; GENERATOR = 0; end
			10'h175: begin freq_div = MI;	HIT = 1 ; GENERATOR = 2; end
			10'h176: begin freq_div = LLA;  HIT = 1 ; GENERATOR = 1; end
			10'h177: begin freq_div = LLA ; 	HIT = 0 ; GENERATOR = 1; end
			10'h178: begin freq_div = LLA;  HIT = 1 ; GENERATOR = 2; end
			10'h179: begin freq_div = LLA; 	HIT = 1 ; GENERATOR = 0; end
			10'h17A: begin freq_div = LLA; HIT = 1 ; GENERATOR = 2; end
			10'h17B: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 1; end
			10'h17C: begin freq_div = MI; HIT = 0 ; GENERATOR = 0; end
			10'h17D: begin freq_div = MI;	 HIT = 1 ; GENERATOR = 1; end
			10'h17E: begin freq_div = LLA;  HIT = 1 ; GENERATOR = 0; end
			10'h17F: begin freq_div = LLA ; HIT = 0 ; GENERATOR = 1; end
			
			10'h180: begin freq_div = LSI; 	HIT = 1 ; GENERATOR = 2; end
			10'h181: begin freq_div = LSI;  	HIT = 0 ;GENERATOR = 0;  end
			10'h182: begin freq_div = LSI; 	 HIT = 1 ; GENERATOR = 1; end
			10'h183: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 2; end
			10'h184: begin freq_div = FA_SO;  HIT = 0 ; GENERATOR = 0; end
			10'h185: begin freq_div = FA_SO; HIT = 1 ;GENERATOR = 2;  end
			10'h186: begin freq_div = SI; 	HIT = 1 ; GENERATOR = 1; end
			10'h187: begin freq_div = SI; 	HIT = 0 ; GENERATOR = 0; end
			10'h188: begin freq_div = SI; 	HIT = 1 ; GENERATOR = 2; end
			10'h189: begin freq_div = LA;  	HIT = 1 ; GENERATOR = 0; end
			10'h18A: begin freq_div = LA; 	 HIT = 0 ; GENERATOR = 2; end
			10'h18B: begin freq_div = FA_SO;  HIT = 1 ; GENERATOR = 1; end
			10'h18C: begin freq_div = FA_SO;  HIT = 0 ; GENERATOR = 1; end
			10'h18D: begin freq_div = MI;		 HIT = 1 ; GENERATOR = 2; end
			10'h18E: begin freq_div = FA_SO;  	HIT = 1 ; GENERATOR = 1; end
			10'h18F: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 1; end
			10'h190: begin freq_div = SI;	 HIT = 1 ; GENERATOR = 2; end
			10'h191: begin freq_div = LA; 	HIT = 1 ; GENERATOR = 1; end
			10'h192: begin freq_div = SO;   HIT = 1 ; GENERATOR = 1; end
			10'h193: begin freq_div = LA; 	HIT = 1 ; GENERATOR = 2; end
			10'h194: begin freq_div = SO; 	HIT = 1 ; GENERATOR = 1; end
			10'h195: begin freq_div = FA_SO;		HIT = 1 ; GENERATOR = 1; end
			10'h196: begin freq_div = SO;  	HIT = 1 ; GENERATOR = 2; end
			10'h197: begin freq_div = FA_SO ; 	HIT = 1 ; GENERATOR = 1; end
			10'h198: begin freq_div = MI;  	HIT = 1 ; GENERATOR = 1; end
			10'h199: begin freq_div = FA_SO; 	HIT = 1 ; GENERATOR = 2; end
			10'h19A: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 1; end
			10'h19B: begin freq_div = RE; 	HIT = 1 ; GENERATOR = 1; end
			10'h19C: begin freq_div = MI; 	HIT = 1 ; GENERATOR = 2; end
			10'h19D: begin freq_div = RE;	 HIT = 1 ; GENERATOR = 2; end
			10'h19E: begin freq_div = DO;  HIT = 1 ; GENERATOR = 0; end
			10'h19F: begin freq_div = LLA ; HIT = 1 ; GENERATOR = 1; end
			
			/*END*/
			10'h1A0: begin freq_div = LSI ;HIT = 1 ; GENERATOR = 0;  end
			10'h1A1: begin freq_div = LSI; HIT = 0 ; GENERATOR = 2;  end
			10'h1A2: begin freq_div = LSO; HIT = 1 ;  GENERATOR = 0; end
			10'h1A3: begin freq_div = LSO; HIT = 0 ;  GENERATOR = 1; end
			10'h1A4: begin freq_div = LLA; HIT = 1 ;  GENERATOR = 0; end
			10'h1A5: begin freq_div = LLA; HIT = 0 ; GENERATOR = 2;  end
			10'h1A6: begin freq_div = LFA; HIT = 1 ; GENERATOR = 0;  end
			10'h1A7: begin freq_div = LFA; HIT = 0 ; GENERATOR = 1;  end
			10'h1A8: begin freq_div = LSI;HIT = 1 ; GENERATOR = 0;  end
			10'h1A9: begin freq_div = LSI; HIT = 0 ; GENERATOR = 2;  end
			10'h1AA: begin freq_div = LSO; HIT = 1 ; GENERATOR = 1;  end
			10'h1AB: begin freq_div = LSO; HIT = 0 ; GENERATOR = 1;  end
			10'h1AC: begin freq_div = LLA; HIT = 1 ; GENERATOR = 2;  end
			10'h1AD: begin freq_div = LLA; HIT = 1 ; GENERATOR = 0;  end
			10'h1AE: begin freq_div = LLA; HIT = 1 ; GENERATOR = 0;  end
			10'h1AF: begin freq_div = LFA; HIT = 1 ; GENERATOR = 0;  end
			
			10'h1B0: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0; end
			10'h1B1: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			10'h1B2: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			10'h1B3: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0; end
			10'h1B4: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			10'h1B5: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			10'h1B6: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0; end
			10'h1B7: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			
			
			10'h3FD: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 2; end
			10'h3FE: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			10'h3FF: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			default: begin freq_div = 20'h00000; HIT = 0 ; GENERATOR = 0; end
			
			endcase
			
			
		2'b01: /*  將軍令!!!  */
		
		
			case (tone)
			/*intro*/
			10'h000: begin freq_div = LLA; HIT = 1 ; GENERATOR = 0;end
			10'h001: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			10'h002: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 2;end
			10'h003: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1;end
			10'h004: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0; end
			10'h005: begin freq_div = MI; HIT = 1 ;  GENERATOR = 1;end
			10'h006: begin freq_div = SO; HIT = 1 ;  GENERATOR = 0;end
			10'h007: begin freq_div = SO; HIT = 0 ;  GENERATOR = 0;end
			10'h008: begin freq_div = LA; HIT = 1 ;  GENERATOR = 0;end
			10'h009: begin freq_div = LA; HIT = 0 ;  GENERATOR = 0;end
			10'h00A: begin freq_div = LA; HIT = 0 ;  GENERATOR = 2;end
			10'h00B: begin freq_div = LA; HIT = 0 ; GENERATOR = 1; end
			10'h00C: begin freq_div = LA; HIT = 0 ; GENERATOR = 0;end
			10'h00D: begin freq_div = MI; HIT = 1 ; GENERATOR = 3; end
			10'h00E: begin freq_div = SO; HIT = 1 ; GENERATOR = 0; end
			10'h00F: begin freq_div = SO; HIT = 0 ; GENERATOR = 0; end
			10'h010: begin freq_div = LA; HIT = 1 ; GENERATOR = 0; end
			10'h011: begin freq_div =  LA; HIT = 0 ; GENERATOR = 0; end
			10'h012: begin freq_div = LA; HIT = 0 ;  GENERATOR = 2;end
			10'h013: begin freq_div = LA; HIT = 0 ; GENERATOR = 1; end
			10'h014: begin freq_div = LA ; HIT = 0 ;GENERATOR = 0; end
			10'h015: begin freq_div = MI; HIT = 1 ;  GENERATOR = 3;end
			10'h016: begin freq_div =  SO; HIT = 1 ; GENERATOR = 0;end
			10'h017: begin freq_div = SO; HIT = 0 ;GENERATOR = 0;end
			10'h018: begin freq_div = HRE; HIT = 1 ;GENERATOR = 0; end
			10'h019: begin freq_div = HRE; HIT = 0 ;  GENERATOR = 2;end
			10'h01A: begin freq_div = HRE; HIT = 0 ;GENERATOR = 0; end
			10'h01B: begin freq_div = HRE; HIT = 0 ;GENERATOR = 0;end
			10'h01C: begin freq_div = HDO; HIT = 1 ; GENERATOR = 0;end
			10'h01D: begin freq_div = HDO; HIT = 0 ;  GENERATOR = 1; end
			10'h01E: begin freq_div =	HDO; HIT = 0 ;  GENERATOR = 1;end
			10'h01F: begin freq_div = HDO; HIT = 0 ; GENERATOR = 1; end
			/* verse */
			10'h020: begin freq_div = LLA; HIT = 1 ;  GENERATOR = 1; end
			10'h021: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;end
			10'h022: begin freq_div = DO; HIT = 1 ;  GENERATOR = 2; end
			10'h023: begin freq_div = RE; HIT = 1 ;  GENERATOR = 2; end
			10'h024: begin freq_div = DO; HIT = 0 ;GENERATOR = 0; end
			10'h025: begin freq_div = RE; HIT = 1 ;  GENERATOR = 1; end
			10'h026: begin freq_div = RE; HIT = 1 ; GENERATOR = 0; end
			10'h027: begin freq_div = DO; HIT = 0 ;  GENERATOR = 1; end
			10'h028: begin freq_div = MI; HIT = 1 ;  GENERATOR = 1; end
			10'h029: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h02A: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h02B: begin freq_div = DO; HIT = 1 ; GENERATOR = 0;  end
			10'h02C: begin freq_div = RE; HIT = 1 ;  GENERATOR = 2; end
			10'h02D: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;  end
			10'h02E: begin freq_div = DO; HIT = 0 ;  GENERATOR = 2; end
			10'h02F: begin freq_div = LLA; HIT = 1 ;  GENERATOR = 1; end
			10'h030: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h031: begin freq_div =  RE; HIT = 1 ; GENERATOR = 0;  end
			10'h032: begin freq_div = DO; HIT = 1 ;  GENERATOR = 1; end
			10'h033: begin freq_div = RE; HIT = 0 ;  GENERATOR = 1; end
			10'h034: begin freq_div =  DO; HIT = 0 ;  GENERATOR = 2; end
			10'h035: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h036: begin freq_div = SO; HIT = 1 ;  GENERATOR = 2; end
			10'h037: begin freq_div = MI; HIT = 1 ;  GENERATOR = 1; end
			10'h038: begin freq_div = MI; HIT = 0 ; GENERATOR = 2;  end
			10'h039: begin freq_div = RE; HIT = 1 ;  GENERATOR = 1; end
			10'h03A: begin freq_div = DO; HIT = 1 ; GENERATOR = 1;  end
			10'h03B: begin freq_div = RE; HIT = 1 ;  GENERATOR = 0; end
			10'h03C: begin freq_div = DO; HIT = 1 ;  GENERATOR = 1; end
			10'h03D: begin freq_div = RE; HIT = 1 ;  GENERATOR = 0; end
			10'h03E: begin freq_div = DO;  HIT = 0 ;  GENERATOR = 2; end
			10'h03F: begin freq_div = LLA; HIT = 1 ;  GENERATOR = 1; end
			
			10'h040: begin freq_div = ZERO; HIT = 0 ;  GENERATOR = 0; end
			10'h041: begin freq_div = RE;   HIT = 1 ; GENERATOR = 1;  end
			10'h042: begin freq_div = DO;   HIT = 1 ;  GENERATOR = 2; end
			10'h043: begin freq_div = RE;   HIT = 0 ; GENERATOR = 1;  end
			10'h044: begin freq_div = DO;  HIT = 1;  GENERATOR = 0; end
			10'h045: begin freq_div = RE;  HIT = 1 ;  GENERATOR = 2; end
			10'h046: begin freq_div = RE;  HIT = 1 ;  GENERATOR = 0; end
			10'h047: begin freq_div = DO;  HIT = 0 ;  GENERATOR = 2; end
			10'h048: begin freq_div = MI;  HIT = 1 ;  GENERATOR = 0; end
			10'h049: begin freq_div = ZERO; HIT = 0 ;  GENERATOR = 2; end
			10'h04A: begin freq_div = RE;  HIT = 1 ;  GENERATOR = 1; end
			10'h04B: begin freq_div = DO;  HIT = 0 ;  GENERATOR = 0; end
			10'h04C: begin freq_div = RE;  HIT = 1 ; GENERATOR = 2;  end
			10'h04D: begin freq_div = RE;  HIT = 1 ;  GENERATOR = 0; end
			10'h04E: begin freq_div = DO;  HIT = 0 ; GENERATOR = 1;  end
			10'h04F: begin freq_div = LLA; HIT = 1 ;  GENERATOR = 1; end
			10'h050: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 1;  end
			10'h051: begin freq_div =  RE; HIT = 1 ;  GENERATOR = 0; end
			10'h052: begin freq_div = DO;  HIT = 1 ;  GENERATOR = 2; end
			10'h053: begin freq_div = RE;  HIT = 1 ;  GENERATOR = 1; end
			10'h054: begin freq_div =  DO; HIT = 0 ;  GENERATOR = 2; end
			10'h055: begin freq_div = RE;  HIT = 1 ;  GENERATOR = 0; end
			10'h056: begin freq_div = SO;  HIT = 1 ; GENERATOR = 2;  end
			10'h057: begin freq_div = MI;  HIT = 1 ; GENERATOR = 1;  end
			10'h058: begin freq_div = MI;  HIT = 0 ;  GENERATOR = 2; end
			10'h059: begin freq_div = RE;  HIT = 1 ; GENERATOR = 1;  end
			10'h05A: begin freq_div = DO;  HIT = 1 ; GENERATOR = 1;  end
			10'h05B: begin freq_div = RE;  HIT = 1 ; GENERATOR = 0;  end
			10'h05C: begin freq_div = DO;  HIT = 1 ;  GENERATOR = 1; end
			10'h05D: begin freq_div = RE;  HIT = 1 ;  GENERATOR = 0; end
			10'h05E: begin freq_div = DO;  HIT = 0 ;  GENERATOR = 2; end
			10'h05F: begin freq_div = LLA; HIT = 1 ; GENERATOR = 1;  end
		
			/*verse2*/
			
			10'h060: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 0;  end
			10'h061: begin freq_div = MI; HIT = 1 ;  GENERATOR = 2; end
			10'h062: begin freq_div = RE; HIT = 1 ;  GENERATOR = 0; end
			10'h063: begin freq_div = DO; HIT = 0 ;  GENERATOR = 1; end
			10'h064: begin freq_div = RE; HIT = 1 ;  GENERATOR = 1; end
			10'h065: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;  end
			10'h066: begin freq_div = MI;  HIT = 1 ; GENERATOR = 2;  end
			10'h067: begin freq_div = LLA; HIT = 1 ; GENERATOR = 1;  end
			10'h068: begin freq_div = ZERO;HIT = 0 ;  GENERATOR = 0; end
			10'h069: begin freq_div = SO; HIT = 1 ; GENERATOR = 1;  end
			10'h06A: begin freq_div = RE; HIT = 1 ; GENERATOR = 1;  end
			10'h06B: begin freq_div = DO; HIT = 0 ;  GENERATOR = 0; end
			10'h06C: begin freq_div = RE; HIT = 1 ;  GENERATOR = 2; end
			10'h06D: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h06E: begin freq_div = DO; HIT = 0 ; GENERATOR = 2;  end
			10'h06F: begin freq_div = MI; HIT = 1 ; GENERATOR = 1;  end
			10'h070: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 0;  end
			10'h071: begin freq_div = SO; HIT = 1 ;  GENERATOR = 2; end
			10'h072: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h073: begin freq_div = DO; HIT = 0 ; GENERATOR = 0;  end
			10'h074: begin freq_div = RE; HIT = 1 ;  GENERATOR = 1; end
			10'h075: begin freq_div = RE; HIT = 0 ;  GENERATOR = 3; end
			10'h076: begin freq_div = DO; HIT = 0 ;  GENERATOR = 1; end
			10'h077: begin freq_div = LLA; HIT = 1 ;  GENERATOR = 1; end
			10'h078: begin freq_div = LA; HIT = 1 ;  GENERATOR = 1; end
			10'h079: begin freq_div = LA; HIT = 1 ; GENERATOR = 1;  end
			10'h07A: begin freq_div = LA; HIT = 1 ; GENERATOR = 0; end
			10'h07B: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h07C: begin freq_div = LA; HIT = 1 ;  GENERATOR = 0; end
			10'h07D: begin freq_div = LA; HIT = 0 ;  GENERATOR = 0; end
			10'h07E: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 2;  end
			10'h07F: begin freq_div = ZERO; HIT = 0 ;  GENERATOR = 1; end
			
			10'h080: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h081: begin freq_div = MI; HIT = 1 ;  GENERATOR = 2; end
			10'h082: begin freq_div = RE; HIT = 1 ; GENERATOR = 1;  end
			10'h083: begin freq_div = DO; HIT = 0 ; GENERATOR = 0;  end
			10'h084: begin freq_div = RE; HIT = 1 ;  GENERATOR = 1; end
			10'h085: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h086: begin freq_div = MI; HIT = 0 ;  GENERATOR = 2; end
			10'h087: begin freq_div = LLA; HIT = 1 ;  GENERATOR = 1; end
			10'h088: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 0;  end
			10'h089: begin freq_div = SO; HIT = 1 ;  GENERATOR = 2; end
			10'h08A: begin freq_div = RE; HIT = 1 ; GENERATOR = 1;  end
			10'h08B: begin freq_div = DO; HIT = 0 ; GENERATOR = 0;  end
			10'h08C: begin freq_div = RE; HIT = 1 ;  GENERATOR = 2; end
			10'h08D: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h08E: begin freq_div = DO; HIT = 0 ; GENERATOR = 2;  end
			10'h08F: begin freq_div = MI; HIT = 1 ;  GENERATOR = 1; end
			10'h090: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 0;  end
			10'h091: begin freq_div = SO; HIT = 1 ;  GENERATOR = 1; end
			10'h092: begin freq_div = RE; HIT = 1 ;  GENERATOR = 2; end
			10'h093: begin freq_div = DO; HIT = 0 ;  GENERATOR = 1; end
			10'h094: begin freq_div = RE; HIT = 1 ; GENERATOR = 1;  end
			10'h095: begin freq_div = RE; HIT = 1 ;  GENERATOR = 2; end
			10'h096: begin freq_div = DO; HIT = 1 ; GENERATOR = 0;  end
			10'h097: begin freq_div = RE; HIT = 1 ; GENERATOR = 2;  end
			10'h098: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h099: begin freq_div = LA; HIT = 0 ;  GENERATOR = 2; end
			10'h09A: begin freq_div = SO; HIT = 1 ; GENERATOR = 0;  end
			10'h09B: begin freq_div = SO; HIT = 0 ;  GENERATOR = 2; end
			10'h09C: begin freq_div = MI; HIT = 1 ;  GENERATOR = 2; end
			10'h09D: begin freq_div = MI; HIT = 0 ; GENERATOR = 0;  end
			10'h09E: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h09F: begin freq_div = MI; HIT = 1 ; GENERATOR = 0;  end
			/* 副歌! */
			10'h0A0: begin freq_div = ZERO;HIT = 0 ;  GENERATOR = 0; end
			10'h0A1: begin freq_div = ZERO; HIT = 0 ;  GENERATOR = 1; end
			10'h0A2: begin freq_div = ZERO; HIT = 0 ;  GENERATOR = 2; end
			10'h0A3: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 2;  end
			10'h0A4: begin freq_div = MI; HIT = 1 ;  GENERATOR = 0; end
			10'h0A5: begin freq_div = MI; HIT = 1 ;  GENERATOR = 2; end
			10'h0A6: begin freq_div = SO; HIT = 1 ; GENERATOR = 0;  end
			10'h0A7: begin freq_div = SO; HIT = 0 ; GENERATOR = 0;  end
			10'h0A8: begin freq_div = LA; HIT = 1 ;  GENERATOR = 3; end
			10'h0A9: begin freq_div = LA; HIT = 0 ; GENERATOR = 0;  end
			10'h0AA: begin freq_div = LA; HIT = 0 ; GENERATOR = 0;  end
			10'h0AB: begin freq_div = SO; HIT = 1 ; GENERATOR = 2;  end
			10'h0AC: begin freq_div = SO; HIT = 0 ;  GENERATOR = 1; end
			10'h0AD: begin freq_div = SO; HIT = 0 ; GENERATOR = 2;  end
			10'h0AE: begin freq_div = MI; HIT = 1 ; GENERATOR = 1;  end
			10'h0AF: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h0B0: begin freq_div = MI; HIT = 1 ; GENERATOR = 1;  end
			10'h0B1: begin freq_div = FA; HIT = 1 ; GENERATOR = 0;  end
			10'h0B2: begin freq_div = MI; HIT = 0 ; GENERATOR = 0;  end
			10'h0B3: begin freq_div = RE; HIT = 1 ; GENERATOR = 1;  end
			10'h0B4: begin freq_div = DO; HIT = 0 ;  GENERATOR = 2; end
			10'h0B5: begin freq_div = DO; HIT = 0 ;  GENERATOR = 3; end
			10'h0B6: begin freq_div = MI; HIT = 1 ; GENERATOR = 0;  end
			10'h0B7: begin freq_div = SO; HIT = 1 ; GENERATOR = 0;  end
			10'h0B8: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h0B9: begin freq_div = LA; HIT = 0 ; GENERATOR = 0;  end
			10'h0BA: begin freq_div = LA; HIT = 0 ;  GENERATOR = 2; end
			10'h0BB: begin freq_div = LA; HIT = 0 ; GENERATOR = 1;  end
			10'h0BC: begin freq_div = LA; HIT = 0 ; GENERATOR = 0;  end
			10'h0BD: begin freq_div = SO; HIT = 1 ; GENERATOR = 2;  end
			10'h0BE: begin freq_div = MI; HIT = 1 ; GENERATOR = 0;  end
			10'h0BF: begin freq_div = RE; HIT = 0 ;  GENERATOR = 0; end
			
			10'h0C0: begin freq_div = MI; HIT = 1 ; GENERATOR = 0;  end
			10'h0C1: begin freq_div = MI; HIT = 0 ; GENERATOR = 2;  end
			10'h0C2: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h0C3: begin freq_div = ZERO; HIT = 0 ;  GENERATOR = 1; end
			10'h0C4: begin freq_div = MI; HIT = 1 ;  GENERATOR = 3; end
			10'h0C5: begin freq_div = MI; HIT = 0 ; GENERATOR = 0;  end
			10'h0C6: begin freq_div = SO; HIT = 1 ; GENERATOR = 0;  end
			10'h0C7: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h0C8: begin freq_div = LA; HIT = 0 ; GENERATOR = 0;  end
			10'h0C9: begin freq_div = LA; HIT = 0 ;  GENERATOR = 2; end
			10'h0CA: begin freq_div = LA; HIT = 0 ;  GENERATOR = 1; end
			10'h0CB: begin freq_div = LA; HIT = 0 ;  GENERATOR = 2; end
			10'h0CC: begin freq_div = SI; HIT = 1 ; GENERATOR = 0;  end
			10'h0CD: begin freq_div = SI; HIT = 1 ; GENERATOR = 2;  end
			10'h0CE: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h0CF: begin freq_div = LA; HIT = 0 ; GENERATOR = 1;  end
			10'h0D0: begin freq_div = SO; HIT = 1 ; GENERATOR = 1;  end
			10'h0D1: begin freq_div = SO; HIT = 0 ; GENERATOR = 1;  end
			10'h0D2: begin freq_div = MI; HIT = 1 ; GENERATOR = 0;  end
			10'h0D3: begin freq_div = SO; HIT = 1 ; GENERATOR = 2;  end
			10'h0D4: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h0D5: begin freq_div = LA; HIT = 0 ;  GENERATOR = 2; end
			10'h0D6: begin freq_div = MI; HIT = 1 ;  GENERATOR = 1; end
			10'h0D7: begin freq_div = MI; HIT = 0 ; GENERATOR = 0;  end
			10'h0D8: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h0D9: begin freq_div = DO; HIT = 1 ;  GENERATOR = 2; end
			10'h0DA: begin freq_div = LLA; HIT = 0 ; GENERATOR = 0;  end
			10'h0DB: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;  end
			10'h0DC: begin freq_div = MI; HIT = 1 ;  GENERATOR = 2; end
			10'h0DD: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;  end
			10'h0DE: begin freq_div = LLA;HIT = 0 ;  GENERATOR = 1; end
			10'h0DF: begin freq_div = MI; HIT = 1 ; GENERATOR = 1;  end
			
			10'h0E0: begin freq_div = MI; HIT = 0 ;  GENERATOR = 1; end
			10'h0E1: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h0E2: begin freq_div = DO; HIT = 1 ; GENERATOR = 0;  end
			10'h0E3: begin freq_div = LLA; HIT = 1 ; GENERATOR = 2;  end
			10'h0E4: begin freq_div = LLA; HIT = 0 ;  GENERATOR = 1; end
			10'h0E5: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 0;  end
			10'h0E6: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h0E7: begin freq_div = MI; HIT = 1 ; GENERATOR = 0;  end
			10'h0E8: begin freq_div = RE; HIT = 0 ; GENERATOR = 0;  end
			10'h0E9: begin freq_div = DO; HIT = 0 ; GENERATOR = 1;  end
			10'h0EA: begin freq_div = LLA; HIT = 0 ;  GENERATOR = 2; end
			10'h0EB: begin freq_div = LLA; HIT = 0 ; GENERATOR = 2;  end
			10'h0EC: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h0ED: begin freq_div = MI; HIT = 1 ; GENERATOR = 0;  end
			10'h0EE: begin freq_div = RE; HIT = 1 ; GENERATOR = 0;  end
			10'h0EF: begin freq_div = DO; HIT = 0 ;  GENERATOR = 3; end
			
			10'h0F0: begin freq_div = LLA;HIT = 0 ; GENERATOR = 0;  end
			10'h0F1: begin freq_div = LLA; HIT = 0 ; GENERATOR = 0;  end
			10'h0F2: begin freq_div = LA; HIT = 1 ;  GENERATOR = 2; end
			10'h0F3: begin freq_div = LA; HIT = 0 ;  GENERATOR = 1; end
			10'h0F4: begin freq_div = LA; HIT = 0 ;  GENERATOR = 3; end
			10'h0F5: begin freq_div = SO; HIT = 1 ; GENERATOR = 0;  end
			10'h0F6: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h0F7: begin freq_div = LA; HIT = 1 ; GENERATOR = 0;  end
			10'h0F8: begin freq_div = ZERO;HIT = 0 ; GENERATOR = 0;  end
			10'h0F9: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h0FA: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h0FB: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h0FC: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h0FD: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h0FE: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			10'h0FF: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;  end
			
			10'h3FD: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 1; end
			10'h3FE: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			10'h3FF: begin freq_div = ZERO; HIT = 0 ; GENERATOR = 0;end
			default: begin freq_div = 20'h00000; HIT = 0 ; GENERATOR = 0; end
			endcase
		endcase
	end


endmodule
