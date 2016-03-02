/*********************************** 
 * Show a crying Pac-man on LCD.   *
 * Each image is 16x16 bits.        *
 ***********************************/

module PAC_MAN(LCD_CLK, RESETN, LCD_DATA, LCD_ENABLE,
       LCD_RW, LCD_RSTN, LCD_CS1, LCD_CS2, LCD_DI,push_0 ,push_1 ,push_4 ,push_7,HIT,point,GENERATOR,ran_data);

	input  LCD_CLK;
	input  RESETN;
	input[1:0] GENERATOR;
	input push_0,push_1,push_4 ,push_7,HIT;
	input [1:0]ran_data;
	output reg [7:0]  LCD_DATA;
	output LCD_ENABLE; 
	output reg LCD_RW;
	output LCD_RSTN;
	output LCD_CS1 ;
	output LCD_CS2 ;
	output reg LCD_DI;
	output reg [15:0]point;


	reg [7:0]  LCD_DATA_NEXT;
	reg LCD_RW_NEXT;
	reg LCD_DI_NEXT;
	reg LCD_CS1_NEXT = 1;
	reg LCD_CS2_NEXT = 1;
	reg [2:0]  STATE, STATE_NEXT;
	reg [2:0]  X_PAGE = 0;
	reg [2:0]	X_PAGE_NEXT = 0;
	reg [6:0]  Y, Y_NEXT;
	reg [2:0] IMAGE = 6;
	reg [2:0] IMAGE_NEXT = 6;
	reg [7:0] PATTERN;
	reg [4:0]  INDEX, INDEX_NEXT;
	reg [15:0] PAUSE_TIME, PAUSE_TIME_NEXT;
	
	reg START, START_NEXT;	
	reg NEW_PAGE, NEW_PAGE_NEXT;
	reg NEW_COL, NEW_COL_NEXT;
	reg [2:0] PAGE_COUNTER, PAGE_COUNTER_NEXT;
	reg [6:0] COL_COUNTER, COL_COUNTER_NEXT;
	reg ENABLE, ENABLE_NEXT;
	reg [6:0]tmp_Y;
	reg SET_R ,SET_L ;
	reg SET_R_NEXT,SET_L_NEXT ;
	reg[2:0] OLD_X = 0;
	reg[2:0] OLD_X_NEXT ;
	//reg[6:0] OLD_Y,OLD_Y_NEXT;
	reg DRAW_LINE_NEXT,DRAW_LINE;
	
	
	reg[15:0] point_next ;
	reg[3:0] counter = 0 ,counter_next;
	reg[2:0] NOTE_IMAGE0 = 6 ,NOTE_IMAGE1 = 6 , NOTE_IMAGE2 = 6 ;
	reg[2:0] NOTE_IMAGE3 = 6, NOTE_IMAGE4 = 6,NOTE_IMAGE5 = 6, NOTE_IMAGE6 = 6,NOTE_IMAGE7 = 6; 
	reg[2:0] NOTE_IMAGE0_NEXT ,NOTE_IMAGE1_NEXT  , NOTE_IMAGE2_NEXT  ;
	reg[2:0] NOTE_IMAGE3_NEXT , NOTE_IMAGE4_NEXT ,NOTE_IMAGE5_NEXT, NOTE_IMAGE6_NEXT,NOTE_IMAGE7_NEXT ;
	reg[2:0] NOTE_X0 ,NOTE_X1 , NOTE_X2 , NOTE_X3 , NOTE_X4 ,NOTE_X5 , NOTE_X6 ,NOTE_X7;
	reg[2:0] NOTE_X0_NEXT ,NOTE_X1_NEXT,NOTE_X2_NEXT,NOTE_X3_NEXT ,NOTE_X4_NEXT ,NOTE_X5_NEXT ,NOTE_X6_NEXT ,NOTE_X7_NEXT;
	reg[6:0] NOTE_Y0 ,NOTE_Y1 , NOTE_Y2 , NOTE_Y3 , NOTE_Y4 ,NOTE_Y5 , NOTE_Y6 ,NOTE_Y7;
	reg[6:0] NOTE_Y0_NEXT ,NOTE_Y1_NEXT , NOTE_Y2_NEXT , NOTE_Y3_NEXT , NOTE_Y4_NEXT ,NOTE_Y5_NEXT , NOTE_Y6_NEXT ,NOTE_Y7_NEXT;
	reg[2:0] tmp = 0;
	reg[2:0] tmp_next;
	//reg GEN_VALID = 1 ,GEN_VALID_NEXT;
	reg[1:0] I_valid = 0;
	reg[1:0] I_valid_next=0 ;
	wire re_start ,con_one;
	
	//added
	reg NEW_GENERATOR0,
		NEW_GENERATOR1,
		NEW_GENERATOR2,
		NEW_GENERATOR3,
		NEW_GENERATOR4,
		NEW_GENERATOR5,
		NEW_GENERATOR6,
		NEW_GENERATOR7,
		NEW_GENERATOR0_NEXT,
		NEW_GENERATOR1_NEXT,
		NEW_GENERATOR2_NEXT,
		NEW_GENERATOR3_NEXT,
		NEW_GENERATOR4_NEXT,
		NEW_GENERATOR5_NEXT,
		NEW_GENERATOR6_NEXT,
		NEW_GENERATOR7_NEXT;
	
	parameter Init = 3'd0, Set_StartLine = 3'd1, Clear_Screen = 3'd2, Copy_Image = 3'd3, Pause = 3'd4 , 
		CD = 3'd5 , SET_image = 3'd6 ;
	//parameter Delay = 16'b1000_0000_0000_0000;,
	//parameter Delay = 16'hFDCC; OK
	//parameter Delay = 16'h8CCC;
	//parameter Delay = 16'hFFCC; OK
	parameter Delay = 16'hFFBF;
	//parameter Delay = 16'hFFFF; NO OK
	assign LCD_ENABLE = LCD_CLK & ENABLE; // when ENABLE=1, LCD write can occur at falling edge of clock 
	assign LCD_RSTN = RESETN;
	assign PAUSED_TO_THE_END = (PAUSE_TIME == 0) ? 1 : 0;	
	assign LCD_CS1 = LCD_CS1_NEXT;
	assign LCD_CS2 = LCD_CS2_NEXT;
	assign re_start = 1'b1;
	assign con_one = 2'b01;
	
	always@(posedge LCD_CLK or negedge RESETN) begin
		if (!RESETN) begin
			STATE    <= Init;
			PAUSE_TIME    <= Delay;
			X_PAGE   <= 0;
			Y  <= 0;
			INDEX 	<=  0;
			LCD_DI   <= 0;
			LCD_RW   <= 0;
			//LCD_DATA  <= 8'b0011111_1;
			IMAGE    <= 6;
			START <= 0;
			NEW_PAGE <= 1'b0;
			NEW_COL <= 1'b0;
			COL_COUNTER <= 0;
			PAGE_COUNTER <= 0;
			ENABLE <= 1'b0;
			SET_R <= 0;
			SET_L <= 0;
			OLD_X <= 0;
			point <= 0;
			counter <= 0;
			tmp <= 0;
			//GEN_VALID <= 1; 
			I_valid <=  0;
			NOTE_X0 <= 0;
			NOTE_X1 <= 0;
			NOTE_X2 <= 0;
			NOTE_X3 <= 0;
			NOTE_X4 <= 0;
			NOTE_X5 <= 0;
			NOTE_X6 <= 0;
			NOTE_X7 <= 0;
			NOTE_Y0 <= 0;
			NOTE_Y1 <= 0;
			NOTE_Y2 <= 0;
			NOTE_Y3 <= 0;
			NOTE_Y4 <= 0;
			NOTE_Y5 <= 0;
			NOTE_Y6 <= 0;
			NOTE_Y7 <= 0;
			NEW_GENERATOR0 <= 0;
			NEW_GENERATOR1 <= 0;
			NEW_GENERATOR2 <= 0;
			NEW_GENERATOR3 <= 0;
			NEW_GENERATOR4 <= 0;
			NEW_GENERATOR5 <= 0;
			NEW_GENERATOR6 <= 0;
			NEW_GENERATOR7 <= 0;
			NOTE_IMAGE0 <= 6;
			NOTE_IMAGE1 <= 6;
			NOTE_IMAGE2 <= 6;
			NOTE_IMAGE3 <= 6;
			NOTE_IMAGE4 <= 6;
			NOTE_IMAGE5 <= 6;
			NOTE_IMAGE6 <= 6;
			NOTE_IMAGE7 <= 6;
		end else begin
			STATE    <= STATE_NEXT;
			PAUSE_TIME    <= PAUSE_TIME_NEXT;
			X_PAGE   <= X_PAGE_NEXT;
			Y  <= Y_NEXT;
			INDEX<= INDEX_NEXT;
			LCD_DI   <= LCD_DI_NEXT;
			LCD_RW   <= LCD_RW_NEXT;
			LCD_DATA <= LCD_DATA_NEXT;
			IMAGE <= IMAGE_NEXT;	
			START <= START_NEXT;	
			NEW_PAGE <= NEW_PAGE_NEXT;
			NEW_COL <= NEW_COL_NEXT;
			COL_COUNTER <= COL_COUNTER_NEXT;
			PAGE_COUNTER <= PAGE_COUNTER_NEXT;
			ENABLE <= ENABLE_NEXT;
			SET_R <= SET_R_NEXT;
			SET_L <= SET_L_NEXT;
			OLD_X <= OLD_X_NEXT;
			//OLD_Y <= OLD_Y_NEXT;
			DRAW_LINE <= DRAW_LINE_NEXT;
			point <= point_next;
			counter <= counter_next;
			tmp <= tmp_next;
			I_valid <= I_valid_next;
			//GEN_VALID <= GEN_VALID_NEXT;
			NOTE_X0 <= NOTE_X0_NEXT;
			NOTE_X1 <= NOTE_X1_NEXT;
			NOTE_X2 <= NOTE_X2_NEXT;
			NOTE_X3 <= NOTE_X3_NEXT;
			NOTE_X4 <= NOTE_X4_NEXT;
			NOTE_X5 <= NOTE_X5_NEXT;
			NOTE_X6 <= NOTE_X6_NEXT;
			NOTE_X7 <= NOTE_X7_NEXT;
			NOTE_Y0 <= NOTE_Y0_NEXT;
			NOTE_Y1 <= NOTE_Y1_NEXT;
			NOTE_Y2 <= NOTE_Y2_NEXT;
			NOTE_Y3 <= NOTE_Y3_NEXT;
			NOTE_Y4 <= NOTE_Y4_NEXT;
			NOTE_Y5 <= NOTE_Y5_NEXT;
			NOTE_Y6 <= NOTE_Y6_NEXT;
			NOTE_Y7 <= NOTE_Y7_NEXT;
			NEW_GENERATOR0 <= NEW_GENERATOR0_NEXT;
			NEW_GENERATOR1 <= NEW_GENERATOR1_NEXT;
			NEW_GENERATOR2 <= NEW_GENERATOR2_NEXT;
			NEW_GENERATOR3 <= NEW_GENERATOR3_NEXT;
			NEW_GENERATOR4 <= NEW_GENERATOR4_NEXT;
			NEW_GENERATOR5 <= NEW_GENERATOR5_NEXT;
			NEW_GENERATOR6 <= NEW_GENERATOR6_NEXT;
			NEW_GENERATOR7 <= NEW_GENERATOR7_NEXT;
			NOTE_IMAGE0 <= NOTE_IMAGE0_NEXT;
			NOTE_IMAGE1 <= NOTE_IMAGE1_NEXT;
			NOTE_IMAGE2 <= NOTE_IMAGE2_NEXT;
			NOTE_IMAGE3 <= NOTE_IMAGE3_NEXT;
			NOTE_IMAGE4 <= NOTE_IMAGE4_NEXT;
			NOTE_IMAGE5 <= NOTE_IMAGE5_NEXT;
			NOTE_IMAGE6 <= NOTE_IMAGE6_NEXT;
			NOTE_IMAGE7 <= NOTE_IMAGE7_NEXT;
		end
	end

	always @(*) begin
		// default assignments
		STATE_NEXT  = STATE;
		PAUSE_TIME_NEXT = PAUSE_TIME;
		X_PAGE_NEXT = X_PAGE;
		Y_NEXT = Y;
		INDEX_NEXT = INDEX;
		LCD_DI_NEXT = LCD_DI;
		LCD_RW_NEXT = LCD_RW;
		LCD_DATA_NEXT = LCD_DATA;	
		LCD_CS1_NEXT = LCD_CS1;
		LCD_CS2_NEXT = LCD_CS2;
		IMAGE_NEXT = IMAGE;
		COL_COUNTER_NEXT = COL_COUNTER; 
		PAGE_COUNTER_NEXT = PAGE_COUNTER;
		START_NEXT =	1'b0;	
		NEW_PAGE_NEXT = 1'b0;
		NEW_COL_NEXT = 1'b0;	
		ENABLE_NEXT = 1'b0;
		SET_R_NEXT = 0;
		SET_L_NEXT = 0;
		OLD_X_NEXT = OLD_X;
		//OLD_Y_NEXT = OLD_Y;
		point_next = point;
		//I_valid_next = I_valid;
		//conter_next = counter;
		
		case(STATE)
			
			Init: begin  //initial state
				STATE_NEXT =  Set_StartLine;
				LCD_CS1_NEXT = 1;
				LCD_CS2_NEXT = 1;
				// prepare LCD instruction to turn display on
				LCD_DI_NEXT = 1'b0;
				LCD_RW_NEXT = 1'b0;
				LCD_DATA_NEXT = 8'b0011111_1;
				ENABLE_NEXT = 1'b1;
				OLD_X_NEXT = 0;
				I_valid_next = I_valid;
				NOTE_X0_NEXT = NOTE_X0;
				NOTE_X1_NEXT = NOTE_X1 ;
				NOTE_X2_NEXT = NOTE_X2 ;
				NOTE_X3_NEXT = NOTE_X3 ;
				NOTE_X4_NEXT = NOTE_X4 ;
				NOTE_X5_NEXT = NOTE_X5 ;
				NOTE_X6_NEXT = NOTE_X6 ;
				NOTE_X7_NEXT = NOTE_X7 ;
				NOTE_Y0_NEXT = NOTE_Y0 ;
				NOTE_Y1_NEXT = NOTE_Y1 ;
				NOTE_Y2_NEXT = NOTE_Y2 ;
				NOTE_Y3_NEXT = NOTE_Y3 ;
				NOTE_Y4_NEXT = NOTE_Y4 ;
				NOTE_Y5_NEXT = NOTE_Y5 ;
				NOTE_Y6_NEXT = NOTE_Y6 ;
				NOTE_Y7_NEXT = NOTE_Y7 ;
				NEW_GENERATOR0_NEXT = NEW_GENERATOR0 ;
				NEW_GENERATOR1_NEXT = NEW_GENERATOR1 ;
				NEW_GENERATOR2_NEXT = NEW_GENERATOR2 ;
				NEW_GENERATOR3_NEXT = NEW_GENERATOR3 ;
				NEW_GENERATOR4_NEXT = NEW_GENERATOR4 ;
				NEW_GENERATOR5_NEXT = NEW_GENERATOR5 ;
				NEW_GENERATOR6_NEXT = NEW_GENERATOR6 ;
				NEW_GENERATOR7_NEXT = NEW_GENERATOR7 ;
				NOTE_IMAGE0_NEXT = NOTE_IMAGE0 ;
				NOTE_IMAGE1_NEXT = NOTE_IMAGE1 ;
				NOTE_IMAGE2_NEXT = NOTE_IMAGE2 ;
				NOTE_IMAGE3_NEXT = NOTE_IMAGE3 ;
				NOTE_IMAGE4_NEXT = NOTE_IMAGE4 ;
				NOTE_IMAGE5_NEXT = NOTE_IMAGE5 ;
				NOTE_IMAGE6_NEXT = NOTE_IMAGE6 ;
				NOTE_IMAGE7_NEXT = NOTE_IMAGE7 ;
				NOTE_IMAGE7_NEXT = NOTE_IMAGE7 ;
			end
			Set_StartLine: begin //set start line
				STATE_NEXT = Clear_Screen;
				// prepare LCD instruction to set start line
				LCD_DI_NEXT = 1'b0;
				LCD_RW_NEXT = 1'b0;
				LCD_DATA_NEXT = 8'b11_000000; // start line = 0
				ENABLE_NEXT = 1'b1;
				START_NEXT = 1'b1;
				
			end
			Clear_Screen: begin
				if (START) begin
					LCD_CS1_NEXT = 1;
					LCD_CS2_NEXT = 1;
					NEW_PAGE_NEXT = 1'b1;
					PAGE_COUNTER_NEXT = 0;
					COL_COUNTER_NEXT = 0;
					X_PAGE_NEXT = 0; // set initial X address
					Y_NEXT = 0; // set initial Y address
				end else	
				if (NEW_PAGE) begin
					// prepare LCD instruction to move to new page
					if(X_PAGE == 7)begin
						DRAW_LINE_NEXT = 1;
					end
					else DRAW_LINE_NEXT = 0;
					LCD_DI_NEXT = 1'b0;
					LCD_RW_NEXT = 1'd0;
					LCD_DATA_NEXT = {5'b10111, X_PAGE};
					ENABLE_NEXT = 1'b1;
					NEW_COL_NEXT = 1'b1;
				end else if (NEW_COL) begin 
					// prepare LCD instruction to move to column 0 
					LCD_DI_NEXT    = 1'b0;
					LCD_RW_NEXT    = 1'd0;
					LCD_DATA_NEXT  = 8'b01_000000; // to move to column 0
					ENABLE_NEXT = 1'b1;
				end else if (COL_COUNTER < 64) begin
					// prepare LCD instruction to write 00000000 into display RAM
					if(DRAW_LINE ==  1)begin
						LCD_DI_NEXT = 1'b1;
						LCD_RW_NEXT = 1'b0;
						LCD_DATA_NEXT = 8'h08;
						ENABLE_NEXT = 1'b1;
						COL_COUNTER_NEXT = COL_COUNTER + 1;
					end
					else begin
						LCD_DI_NEXT    = 1'b1;
						LCD_RW_NEXT    = 1'd0;
						LCD_DATA_NEXT  = 8'b00000000;
						ENABLE_NEXT = 1'b1;
						COL_COUNTER_NEXT = COL_COUNTER + 1;
					end
				end else begin
					/*if(LCD_CS2 == 0)begin
						if(LCD_CS1 == 1)begin
							LCD_CS1_NEXT = 0;
							LCD_CS2_NEXT = 1;
							COL_COUNTER_NEXT = 0;
						end
					end
					else begin // CS2 = 1
						if(LCD_CS1 == 0)begin
							LCD_CS1_NEXT = 1;
							LCD_CS2_NEXT = 0;*/
						
							if (PAGE_COUNTER == 7) begin // last page of screen
								STATE_NEXT = SET_image;
								//STATE_NEXT = Copy_Image;
								//START_NEXT = 1'b1;
								//I_valid_next = 0;
								//counter_next = 0;
							end else begin
								// prepare to change page
								X_PAGE_NEXT  = X_PAGE + 1;
								NEW_PAGE_NEXT = 1'b1;
								PAGE_COUNTER_NEXT = PAGE_COUNTER + 1;
								COL_COUNTER_NEXT = 0;
							end
						//end
					//end
				end
			end						
			Copy_Image: begin // write image pattern into LCD RAM
				if (START) begin
				
					
					
					//X_PAGE_NEXT = 3;  // image initial X address
					
/*單純判斷按下與加分*/					
					
					//STATE_NEXT = SET_image;
					/*else begin
						//X_PAGE_NEXT = OLD_X + 2;
						//Y_NEXT = OLD_Y; // image initial Y address	
					end*/
					
					if(I_valid == 3)begin
							
							if(push_0)begin
								if(Y[6:5] ==  0 ) begin	
									if(point_next > 9) point_next=0;
									else point_next = point + 1;
								end					
							end else if(push_1)begin
								if(Y[6:5] ==  1 ) begin	
									if(point_next > 9) point_next=0;
									else point_next = point + 1;
								end
							end else if(push_4)begin
								if(Y[6:5] ==  2  )begin	
									if(point_next > 9) point_next=0;
									else point_next = point + 1;
								end
							end else if(push_7)begin
								if(Y[6:5] ==  3  ) begin	
									if(point_next > 9) point_next=0;
									else point_next = point + 1;
								end								
							end else point_next = point;
					end
					
					if(I_valid == 0)begin
						X_PAGE_NEXT = 0;
						Y_NEXT = 0 ;
						IMAGE_NEXT = 6;
						STATE_NEXT = SET_image;
					end 
					else begin
						
						NEW_PAGE_NEXT = 1'b1;
						PAGE_COUNTER_NEXT = 0;
						COL_COUNTER_NEXT = 0;
						
					end 
				end else if (NEW_PAGE) begin
					// prepare LCD instruction to move to new page 
					tmp_Y = Y+COL_COUNTER;
						if(tmp_Y > 63)begin
							LCD_CS1_NEXT = 0;
							LCD_CS2_NEXT = 1;
						end
						else begin
							LCD_CS1_NEXT = 1;
							LCD_CS2_NEXT = 0;
						end
					//if(I_valid == 1)begin
						
						
						LCD_DI_NEXT = 1'b0;
						LCD_RW_NEXT = 1'b0;
						LCD_DATA_NEXT = {5'b10111, X_PAGE}; 
						ENABLE_NEXT = 1'b1;
						NEW_COL_NEXT = 1'b1;
					/*end
					else begin
						STATE_NEXT = SET_image;
						//counter_next = counter +1;
						//ENABLE_NEXT = 1'b0;
					end*/
					
				end else if (NEW_COL) begin
					// prepare LCD instruction to move to new column
					tmp_Y = Y+COL_COUNTER;
					if(tmp_Y > 63)begin
						LCD_CS1_NEXT = 0;
						LCD_CS2_NEXT = 1;
						LCD_DI_NEXT = 1'b0;
						LCD_RW_NEXT = 1'b0;
						LCD_DATA_NEXT = {2'b01,tmp_Y[5:0]};
						ENABLE_NEXT = 1'b1;
						SET_R_NEXT = 1;
					end
					else begin
						LCD_CS1_NEXT = 1;
						LCD_CS2_NEXT = 0;
						LCD_DI_NEXT = 1'b0;
						LCD_RW_NEXT = 1'b0;
						if(Y > 63) begin
							LCD_DATA_NEXT = {2'b01,tmp_Y[5:0]};
						end
						else LCD_DATA_NEXT = {2'b01,Y[5:0]};
						ENABLE_NEXT = 1'b1;
						SET_L_NEXT = 1;
					end					
				end else if (COL_COUNTER < 16) begin //load image 1 byte at a time, 16 is the width of image
					// prepare LCD instruction to write image data into display RAM
					tmp_Y = Y+COL_COUNTER;
					if(tmp_Y > 63)begin
						LCD_CS1_NEXT = 0;
						LCD_CS2_NEXT = 1;
						if(SET_R == 0 && tmp_Y == 64)begin 
							NEW_PAGE_NEXT = 1;						
						end
					end
					else begin
						LCD_CS1_NEXT = 1;
						LCD_CS2_NEXT = 0;
						if(SET_L == 0 && tmp_Y == 0)begin 
							NEW_PAGE_NEXT = 1;								
						end					
					end
					
					if(NEW_PAGE_NEXT ==0) begin
							LCD_DI_NEXT = 1'b1;
							LCD_RW_NEXT = 1'b0;
							LCD_DATA_NEXT = PATTERN;
							ENABLE_NEXT = 1'b1;
							INDEX_NEXT = INDEX + 1;
							COL_COUNTER_NEXT = COL_COUNTER + 1;
					end
				end else begin 
					if (PAGE_COUNTER == 1) begin // last page of image
					
						
						STATE_NEXT = SET_image;
						
					end else begin
						// prepare to change page
						X_PAGE_NEXT = X_PAGE + 1;		
						NEW_PAGE_NEXT = 1'b1;
						PAGE_COUNTER_NEXT = PAGE_COUNTER + 1;
						COL_COUNTER_NEXT = 0;
					end
				end				
			end
			Pause: begin
				if (PAUSED_TO_THE_END) begin
					STATE_NEXT = Clear_Screen;
					//STATE_NEXT = CD;
					START_NEXT = 1'b1;
					//OLD_X_NEXT = X_PAGE -1;
					//OLD_Y_NEXT = Y_NEXT;
					
				end 
				else STATE_NEXT = Pause;
				PAUSE_TIME_NEXT = PAUSE_TIME - 1; 
			end
			
			CD:begin
					
						case(tmp)
							3'd0:begin
								if(GENERATOR == 1)begin
									NOTE_X0_NEXT = 0;
									NOTE_Y0_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE0_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR0_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X0_NEXT = 0;
									NOTE_Y0_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE0_NEXT = {0,ran_data};
									NEW_GENERATOR0_NEXT =1;
									NOTE_X1_NEXT = 0 ;
									NOTE_Y1_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE1_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR1_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X0_NEXT = 0;
									NOTE_Y0_NEXT  ={ran_data , 5'b00101 };
									NOTE_IMAGE0_NEXT = {0,ran_data};
									NEW_GENERATOR0_NEXT =1;
									NOTE_X1_NEXT = 0 ;
									NOTE_Y1_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE1_NEXT = {0,ran_data};
									NEW_GENERATOR1_NEXT =1;
									NOTE_X2_NEXT = 0 ;
									NOTE_Y2_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE2_NEXT = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR2_NEXT =1;
								end
								else begin
									//NOTE_X0_NEXT = 0;
									//NOTE_Y0_NEXT  = 0;
									//NOTE_IMAGE0_NEXT = 6;
									NEW_GENERATOR0_NEXT =0;
								end
							end
							3'd1:begin
								if(GENERATOR == 1)begin
									NOTE_X1_NEXT = 0;
									NOTE_Y1_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE1_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR1_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X1_NEXT = 0 ;
									NOTE_Y1_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE1_NEXT = {0,ran_data};
									NEW_GENERATOR1_NEXT =1;
									NOTE_X2_NEXT = 0 ;
									NOTE_Y2_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE2_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR2_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X1_NEXT = 0;
									NOTE_Y1_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE1_NEXT = {0,ran_data};
									NEW_GENERATOR1_NEXT =1;
									NOTE_X2_NEXT = 0;
									NOTE_Y2_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE2_NEXT = {0,ran_data};
									NEW_GENERATOR2_NEXT =1;
									NOTE_X3_NEXT = 0 ;
									NOTE_Y3_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE3_NEXT = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR3_NEXT =1;
								end
								else begin
									//NOTE_X1_NEXT = 0;
									//NOTE_Y1_NEXT  = 0;
									//NOTE_IMAGE1_NEXT = 6;
									NEW_GENERATOR1_NEXT =0;
								end
							end
							3'd2:begin
								if(GENERATOR == 1)begin
									NOTE_X2_NEXT = 0 ;
									NOTE_Y2_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE2_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR2_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X2_NEXT = 0 ;
									NOTE_Y2_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE2_NEXT = {0,ran_data};
									NEW_GENERATOR2_NEXT =1;			
									NOTE_X3_NEXT = 0 ;
									NOTE_Y3_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE3_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR3_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X2_NEXT = 0;
									NOTE_Y2_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE2_NEXT = {0,ran_data};
									NEW_GENERATOR2_NEXT =1;
									NOTE_X3_NEXT = 0 ;
									NOTE_Y3_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE3_NEXT = {0,ran_data};
									NEW_GENERATOR3_NEXT =1;			
									NOTE_X4_NEXT = 0 ;
									NOTE_Y4_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE4_NEXT = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR4_NEXT =1;
								end
								else begin
									//NOTE_X2_NEXT = 0;
									//NOTE_Y2_NEXT  = 0;
									//NOTE_IMAGE2_NEXT = 6;
									NEW_GENERATOR2_NEXT =0;
								end
							end
							3'd3:begin
								if(GENERATOR == 1)begin
									NOTE_X3_NEXT = 0 ;
									NOTE_Y3_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE3_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR3_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X3_NEXT = 0 ;
									NOTE_Y3_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE3_NEXT = {0,ran_data};
									NEW_GENERATOR3_NEXT =1;
									NOTE_X4_NEXT = 0 ;
									NOTE_Y4_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE4_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR4_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X3_NEXT = 0;
									NOTE_Y3_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE3_NEXT = {0,ran_data};
									NEW_GENERATOR3_NEXT =1;
									NOTE_X4_NEXT = 0 ;
									NOTE_Y4_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE4_NEXT = {0,ran_data};
									NEW_GENERATOR4_NEXT =1;
									NOTE_X5_NEXT = 0 ;
									NOTE_Y5_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE5_NEXT = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR5_NEXT =1;
								end
								else begin
									//NOTE_X3_NEXT = 0;
									//NOTE_Y3_NEXT  = 0;
									//NOTE_IMAGE3_NEXT = 6;
									NEW_GENERATOR3_NEXT =0;
								end
							end
							3'd4:begin
								if(GENERATOR == 1)begin
									NOTE_X4_NEXT = 0 ;
									NOTE_Y4_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE4_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR4_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X4_NEXT = 0 ;
									NOTE_Y4_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE4_NEXT = {0,ran_data};
									NEW_GENERATOR4_NEXT =1;
									NOTE_X5_NEXT = 0 ;
									NOTE_Y5_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE5_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR5_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X4_NEXT = 0;
									NOTE_Y4_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE4_NEXT = {0,ran_data};
									NEW_GENERATOR4_NEXT=1;
									NOTE_X5_NEXT = 0 ;
									NOTE_Y5_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE5_NEXT = {0,ran_data};
									NEW_GENERATOR5_NEXT =1;
									NOTE_X6_NEXT = 0 ;
									NOTE_Y6_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE6_NEXT = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR6_NEXT =1;
								end
								else begin
									//NOTE_X4_NEXT = 0;
									//NOTE_Y4_NEXT  = 0;
									//NOTE_IMAGE4_NEXT = 6;
									NEW_GENERATOR4_NEXT =0;
								end
							end
							3'd5:begin
								if(GENERATOR == 1)begin
									NOTE_X5_NEXT = 0 ;
									NOTE_Y5_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE5_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR5_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X5_NEXT = 0 ;
									NOTE_Y5_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE5_NEXT = {0,ran_data};
									NEW_GENERATOR5_NEXT=1;
									NOTE_X6_NEXT = 0 ;
									NOTE_Y6_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE6_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR6_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X5_NEXT = 0;
									NOTE_Y5_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE5_NEXT = {0,ran_data};
									NEW_GENERATOR5_NEXT =1;
									NOTE_X6_NEXT = 0 ;
									NOTE_Y6_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE6_NEXT = {0,ran_data};
									NEW_GENERATOR6_NEXT =1;
									NOTE_X7_NEXT = 0 ;
									NOTE_Y7_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE7_NEXT = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR7_NEXT =1;
								end
								else begin
									//NOTE_X5_NEXT = 0;
									//NOTE_Y5_NEXT  = 0;
									//NOTE_IMAGE5_NEXT = 6;
									NEW_GENERATOR5_NEXT =0;
								end
							end
							3'd6:begin
								if(GENERATOR == 1)begin
									NOTE_X6_NEXT = 0 ;
									NOTE_Y6_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE6_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR6_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X6_NEXT = 0 ;
									NOTE_Y6_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE6_NEXT = {0,ran_data};
									NEW_GENERATOR6_NEXT =1;
									NOTE_X7_NEXT = 0 ;
									NOTE_Y7_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE7_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR7_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X6_NEXT = 0;
									NOTE_Y6_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE6_NEXT = {0,ran_data};
									NEW_GENERATOR6_NEXT =1;
									NOTE_X7_NEXT = 0 ;
									NOTE_Y7_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE7_NEXT = {0,ran_data};
									NEW_GENERATOR7_NEXT =1;
									NOTE_X0_NEXT = 0 ;
									NOTE_Y0_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE0_NEXT = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR0_NEXT =1;
								end
								else begin
									//NOTE_X6_NEXT = 0;
									//NOTE_Y6_NEXT  = 0;
									//NOTE_IMAGE6_NEXT = 6;
									NEW_GENERATOR6_NEXT =0;
								end
							end
							3'd7:begin
								if(GENERATOR == 1)begin
									NOTE_X7_NEXT = 0 ;
									NOTE_Y7_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE7_NEXT = {0,ran_data};
									tmp_next = tmp +1;
									NEW_GENERATOR7_NEXT =1;
								end
								else if(GENERATOR == 2)begin
									NOTE_X7_NEXT = 0 ;
									NOTE_Y7_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE7_NEXT = {0,ran_data};
									NEW_GENERATOR7_NEXT =1;
									NOTE_X0_NEXT = 0 ;
									NOTE_Y0_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE0_NEXT = {0,ran_data};
									tmp_next = tmp +2;
									NEW_GENERATOR0_NEXT =1;
								end
								else if(GENERATOR == 3)begin
									NOTE_X7_NEXT = 0;
									NOTE_Y7_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE7_NEXT = {0,ran_data};
									NEW_GENERATOR7_NEXT =1;
									NOTE_X0_NEXT = 0 ;
									NOTE_Y0_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE0_NEXT = {0,ran_data};
									NEW_GENERATOR0_NEXT =1;
									NOTE_X1_NEXT = 0 ;
									NOTE_Y1_NEXT  = {ran_data , 5'b00101 };
									NOTE_IMAGE1_NEXT  = {0,ran_data};
									tmp_next = tmp +3;
									NEW_GENERATOR1_NEXT =1;
								end
								else begin
									//NOTE_X7_NEXT = 0;
									//NOTE_Y7_NEXT  = 0;
									//NOTE_IMAGE7_NEXT = 6;
									NEW_GENERATOR7_NEXT =0;
								end
							end
						endcase
					//tmp_next = tmp + GENERATOR ;	
					//STATE_NEXT =  Clear_Screen;
					//START_NEXT = 1'b1;
					STATE_NEXT =  Pause;
					PAUSE_TIME_NEXT = Delay;
			end
			SET_image: begin
			
			
						
			if(counter > 7 )begin
				X_PAGE_NEXT = 0;
				Y_NEXT = 0 ;
				IMAGE_NEXT = 6;
				STATE_NEXT = CD;
				counter_next = 0;
				I_valid_next = 0;
			end
			else begin
				case(counter)//TODO : 不知道要畫哪一張
							4'd0:begin
								
								if(NEW_GENERATOR0 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X0;
									Y_NEXT = NOTE_Y0 ;
									IMAGE_NEXT = NOTE_IMAGE0;
									NOTE_X0_NEXT =2;
									//NOTE_Y0_NEXT = NOTE_Y0;
									NOTE_IMAGE0_NEXT = NOTE_IMAGE0;
									I_valid_next = con_one;
									NEW_GENERATOR0_NEXT = 0;
								end
								else begin
									if(NOTE_IMAGE0 == 6)begin
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y0 ;
										IMAGE_NEXT = 6 ;
										NOTE_X0_NEXT = 0;
										//NOTE_Y0_NEXT = NOTE_Y0;
										NOTE_IMAGE0_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
										X_PAGE_NEXT = NOTE_X0;
										Y_NEXT = NOTE_Y0 ;
										IMAGE_NEXT = NOTE_IMAGE0;
										if(NOTE_X0 == 6 )begin  //last picture
//											X_PAGE_NEXT = NOTE_X0;
//											Y_NEXT = NOTE_Y0 ;
//											IMAGE_NEXT = NOTE_IMAGE0 ;
											NOTE_X0_NEXT = 0;
											//NOTE_Y0_NEXT = NOTE_Y0;
											NOTE_IMAGE0_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X0 == 4)begin 
//											X_PAGE_NEXT = NOTE_X0;
//											Y_NEXT = NOTE_Y0 ;
//											IMAGE_NEXT = NOTE_IMAGE0 ;
											NOTE_X0_NEXT = 6;
											//NOTE_Y0_NEXT = NOTE_Y0;
											NOTE_IMAGE0_NEXT = NOTE_IMAGE0;
											I_valid_next = con_one;
										end
										else begin
											
											NOTE_X0_NEXT = 4;
											//NOTE_Y0_NEXT = NOTE_Y0;
											NOTE_IMAGE0_NEXT = NOTE_IMAGE0;
											I_valid_next = con_one;
										end	
									end
								end
								
							end
							4'd1:begin
								if(NEW_GENERATOR1 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X1;
									Y_NEXT = NOTE_Y1 ;
									IMAGE_NEXT = NOTE_IMAGE1;
									NOTE_X1_NEXT = 2;
									//NOTE_Y1_NEXT = NOTE_Y1;
									NOTE_IMAGE1_NEXT = NOTE_IMAGE1;
									I_valid_next = con_one;
									NEW_GENERATOR1_NEXT = 0;				
								end
								else begin
									if(NOTE_IMAGE1 == 6)begin  
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y1 ;
										IMAGE_NEXT = 6 ;
										NOTE_X1_NEXT = 0;
										//NOTE_Y1_NEXT = NOTE_Y1;
										NOTE_IMAGE1_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
										X_PAGE_NEXT = NOTE_X1;
											Y_NEXT = NOTE_Y1 ;
											IMAGE_NEXT =  NOTE_IMAGE1 ;
										if(NOTE_X1 == 6 )begin //last picture
//											X_PAGE_NEXT = NOTE_X1;
//											Y_NEXT = NOTE_Y1 ;
//											IMAGE_NEXT =  NOTE_IMAGE1 ;
											NOTE_X1_NEXT = 0;
											//NOTE_Y1_NEXT = NOTE_Y1;
											NOTE_IMAGE1_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X1 == 4 ) begin
//											X_PAGE_NEXT = NOTE_X1;
//											Y_NEXT = NOTE_Y1 ;
//											IMAGE_NEXT = NOTE_IMAGE1;
											NOTE_X1_NEXT = 6;
											//NOTE_Y1_NEXT = NOTE_Y1;
											NOTE_IMAGE1_NEXT = NOTE_IMAGE1;
											I_valid_next = con_one;
										end	
										else begin
//											X_PAGE_NEXT = NOTE_X1;
//											Y_NEXT = NOTE_Y1 ;
//											IMAGE_NEXT = NOTE_IMAGE1;
											NOTE_X1_NEXT = 4;
											//NOTE_Y1_NEXT = NOTE_Y1;
											NOTE_IMAGE1_NEXT = NOTE_IMAGE1;
											I_valid_next = con_one;
										end	
									end
								end
								
							end
							4'd2:begin
								if(NEW_GENERATOR2 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X2;
									Y_NEXT = NOTE_Y2 ;
									IMAGE_NEXT = NOTE_IMAGE2;
									NOTE_X2_NEXT = 2;
									//NOTE_Y2_NEXT = NOTE_Y2;
									NOTE_IMAGE2_NEXT = NOTE_IMAGE2;
									I_valid_next = con_one;
									NEW_GENERATOR2_NEXT = 0;	
								end
								else begin
									if(NOTE_IMAGE2 == 6)begin
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y2 ;
										IMAGE_NEXT = 6 ;
										NOTE_X2_NEXT = 0;
										//NOTE_Y2_NEXT = NOTE_Y2;
										NOTE_IMAGE2_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
										X_PAGE_NEXT = NOTE_X2;
											Y_NEXT = NOTE_Y2 ;
											IMAGE_NEXT = NOTE_IMAGE2 ;
										if(NOTE_X2 == 6 )begin  //last picture
//											X_PAGE_NEXT = NOTE_X2;
//											Y_NEXT = NOTE_Y2 ;
//											IMAGE_NEXT = NOTE_IMAGE2 ;
											NOTE_X2_NEXT = 0;
											//NOTE_Y2_NEXT = NOTE_Y2;
											NOTE_IMAGE2_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X2 == 4 )begin
//											X_PAGE_NEXT = NOTE_X2;
//											Y_NEXT = NOTE_Y2 ;
//											IMAGE_NEXT = NOTE_IMAGE2;
											NOTE_X2_NEXT = 6;
											//NOTE_Y2_NEXT = NOTE_Y2;
											NOTE_IMAGE2_NEXT = NOTE_IMAGE2;
											I_valid_next = con_one;
										end	
										else begin
//											X_PAGE_NEXT = NOTE_X2;
//											Y_NEXT = NOTE_Y2 ;
//											IMAGE_NEXT = NOTE_IMAGE2;
											NOTE_X2_NEXT = 4;
											//NOTE_Y2_NEXT = NOTE_Y2;
											NOTE_IMAGE2_NEXT = NOTE_IMAGE2;
											I_valid_next = con_one;
										end	
									end
								end
								
							end
							4'd3:begin
								if(NEW_GENERATOR3 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X3;
									Y_NEXT = NOTE_Y3 ;
									IMAGE_NEXT = NOTE_IMAGE3;
									NOTE_X3_NEXT = 2 ;
									//NOTE_Y3_NEXT = NOTE_Y3;
									NOTE_IMAGE3_NEXT = NOTE_IMAGE3;
									I_valid_next = con_one;
									NEW_GENERATOR3_NEXT = 0;
								end
								else begin
									if(NOTE_IMAGE3 == 6)begin
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y3 ;
										IMAGE_NEXT = 6 ;
										NOTE_X3_NEXT = 0;
										//NOTE_Y3_NEXT = NOTE_Y3;
										NOTE_IMAGE3_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
										X_PAGE_NEXT = NOTE_X3;
											Y_NEXT = NOTE_Y3 ;
											IMAGE_NEXT = NOTE_IMAGE3 ;
										if(NOTE_X3 == 6 )begin  //last picture
//											X_PAGE_NEXT = NOTE_X3;
//											Y_NEXT = NOTE_Y3 ;
//											IMAGE_NEXT = NOTE_IMAGE3 ;
											NOTE_X3_NEXT =  NOTE_X3 +2;
											//NOTE_Y3_NEXT = NOTE_Y3;
											NOTE_IMAGE3_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X3 == 4)begin
//											X_PAGE_NEXT = NOTE_X3;
//											Y_NEXT = NOTE_Y3 ;
//											IMAGE_NEXT = NOTE_IMAGE3;
											NOTE_X3_NEXT = 6;
											//NOTE_Y3_NEXT = NOTE_Y3;
											NOTE_IMAGE3_NEXT = NOTE_IMAGE3;
											I_valid_next =con_one;
										end	
										else begin
//											X_PAGE_NEXT = NOTE_X3;
//											Y_NEXT = NOTE_Y3 ;
//											IMAGE_NEXT = NOTE_IMAGE3;
											NOTE_X3_NEXT = 4;
											//NOTE_Y3_NEXT = NOTE_Y3;
											NOTE_IMAGE3_NEXT = NOTE_IMAGE3;
											I_valid_next = con_one;
										end	
									end
								end
									
							end
							4'd4:begin
								if(NEW_GENERATOR4 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X4;
									Y_NEXT = NOTE_Y4 ;
									IMAGE_NEXT = NOTE_IMAGE4;
									NOTE_X4_NEXT = 2 ;
									//NOTE_Y4_NEXT = NOTE_Y4;
									NOTE_IMAGE4_NEXT = NOTE_IMAGE4;
									I_valid_next = con_one;
									NEW_GENERATOR4_NEXT = 0;
								end
								else begin
									if(NOTE_IMAGE4 == 6)begin 
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y4 ;
										IMAGE_NEXT = 6 ;
										NOTE_X4_NEXT = 0;
										//NOTE_Y4_NEXT = NOTE_Y4;
										NOTE_IMAGE4_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
									X_PAGE_NEXT = NOTE_X4;
											Y_NEXT = NOTE_Y4 ;
											IMAGE_NEXT = NOTE_IMAGE4 ;
										if(NOTE_X4 == 6 )begin  //last picture
//											X_PAGE_NEXT = NOTE_X4;
//											Y_NEXT = NOTE_Y4 ;
//											IMAGE_NEXT = NOTE_IMAGE4 ;
											NOTE_X4_NEXT = 0;
											//NOTE_Y4_NEXT = NOTE_Y4;
											NOTE_IMAGE4_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X4 == 4 )begin
//											X_PAGE_NEXT = NOTE_X4;
//											Y_NEXT = NOTE_Y4 ;
//											IMAGE_NEXT = NOTE_IMAGE4;
											NOTE_X4_NEXT = 6;
											//NOTE_Y4_NEXT = NOTE_Y4;
											NOTE_IMAGE4_NEXT = NOTE_IMAGE4;
											I_valid_next = con_one;
										end
										else begin
//											X_PAGE_NEXT = NOTE_X4;
//											Y_NEXT = NOTE_Y4 ;
//											IMAGE_NEXT = NOTE_IMAGE4;
											NOTE_X4_NEXT = 4;
											//NOTE_Y4_NEXT = NOTE_Y4;
											NOTE_IMAGE4_NEXT = NOTE_IMAGE4;
											I_valid_next = con_one;
										end	
									end
								end
									
							end
							4'd5:begin
								if(NEW_GENERATOR5 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X5;
									Y_NEXT = NOTE_Y5 ;
									IMAGE_NEXT = NOTE_IMAGE5;
									NOTE_X5_NEXT = 2;
									//NOTE_Y5_NEXT = NOTE_Y5;
									NOTE_IMAGE5_NEXT = NOTE_IMAGE5;
									I_valid_next = con_one;
									NEW_GENERATOR5_NEXT = 0;
								end
								else begin
									if(NOTE_IMAGE5 == 6)begin 
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y5 ;
										IMAGE_NEXT = 6 ;
										NOTE_X5_NEXT = 0;
										//NOTE_Y5_NEXT = NOTE_Y5;
										NOTE_IMAGE5_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
									X_PAGE_NEXT = NOTE_X5;
											Y_NEXT = NOTE_Y5 ;
											IMAGE_NEXT = NOTE_IMAGE5 ;
										if(NOTE_X5 == 6 )begin  //last picture
//											X_PAGE_NEXT = NOTE_X5;
//											Y_NEXT = NOTE_Y5 ;
//											IMAGE_NEXT = NOTE_IMAGE5 ;
											NOTE_X5_NEXT = 0;
											//NOTE_Y5_NEXT = NOTE_Y5;
											NOTE_IMAGE5_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X5 == 4 )begin
//											X_PAGE_NEXT = NOTE_X5;
//											Y_NEXT = NOTE_Y5 ;
//											IMAGE_NEXT = NOTE_IMAGE5;
											NOTE_X5_NEXT = 6;
											//NOTE_Y5_NEXT = NOTE_Y5;
											NOTE_IMAGE5_NEXT = NOTE_IMAGE5;
											I_valid_next =con_one;
										end
										else begin
//											X_PAGE_NEXT = NOTE_X5;
//											Y_NEXT = NOTE_Y5 ;
//											IMAGE_NEXT = NOTE_IMAGE5;
											NOTE_X5_NEXT = 4;
											//NOTE_Y5_NEXT = NOTE_Y5;
											NOTE_IMAGE5_NEXT = NOTE_IMAGE5;
											I_valid_next = con_one;
										end	
									end
								end
									
							end
							4'd6:begin
								if(NEW_GENERATOR6 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X6;
									Y_NEXT = NOTE_Y6;
									IMAGE_NEXT = NOTE_IMAGE6;
									NOTE_X6_NEXT = 2;
									//NOTE_Y6_NEXT = NOTE_Y6;
									NOTE_IMAGE6_NEXT = NOTE_IMAGE6;
									I_valid_next = con_one;
									NEW_GENERATOR6_NEXT = 0;	
								end
								else begin
									if(NOTE_IMAGE6 == 6)begin
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y6 ;
										IMAGE_NEXT = 6 ;
										NOTE_X6_NEXT = 0;
										//NOTE_Y6_NEXT = NOTE_Y6;
										NOTE_IMAGE6_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
										X_PAGE_NEXT = NOTE_X6;
											Y_NEXT = NOTE_Y6 ;
											IMAGE_NEXT = NOTE_IMAGE6 ;
										if(NOTE_X6 == 6 )begin  //last picture
//											X_PAGE_NEXT = NOTE_X6;
//											Y_NEXT = NOTE_Y6 ;
//											IMAGE_NEXT = NOTE_IMAGE6 ;
											NOTE_X6_NEXT = 0 ;
											//NOTE_Y6_NEXT = NOTE_Y6;
											NOTE_IMAGE6_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X6 == 4 )begin
//											X_PAGE_NEXT = NOTE_X6 +2;
//											Y_NEXT = NOTE_Y6 ;
//											IMAGE_NEXT = NOTE_IMAGE6;
											NOTE_X6_NEXT = 6;
											//NOTE_Y6_NEXT = NOTE_Y6;
											NOTE_IMAGE6_NEXT = NOTE_IMAGE6;
											I_valid_next = con_one;
										end	
										else begin
//											X_PAGE_NEXT = NOTE_X6 ;
//											Y_NEXT = NOTE_Y6 ;
//											IMAGE_NEXT = NOTE_IMAGE6;
											NOTE_X6_NEXT =4;
											//NOTE_Y6_NEXT = NOTE_Y6;
											NOTE_IMAGE6_NEXT = NOTE_IMAGE6;
											I_valid_next = con_one;
										end	
									end
								end
								
							end
								
							4'd7:begin
								if(NEW_GENERATOR7 == 1)begin //第幾張被產生 0-7物件被new了
									X_PAGE_NEXT = NOTE_X7;
									Y_NEXT = NOTE_Y7 ;
									IMAGE_NEXT = NOTE_IMAGE7;
									NOTE_X7_NEXT = 2 ;
									//NOTE_Y7_NEXT = NOTE_Y7;
									NOTE_IMAGE7_NEXT = NOTE_IMAGE7;
									I_valid_next = con_one;
									NEW_GENERATOR7_NEXT = 0;
								end
								else begin
									if(NOTE_IMAGE7 == 6)begin
										X_PAGE_NEXT = 0;
										Y_NEXT = NOTE_Y7 ;
										IMAGE_NEXT = 6 ;
										NOTE_X7_NEXT = 0;
										//NOTE_Y7_NEXT = NOTE_Y7;
										NOTE_IMAGE7_NEXT = 6;
										I_valid_next = 0;
									end
									else begin
									X_PAGE_NEXT = NOTE_X7;
											Y_NEXT = NOTE_Y7 ;
											IMAGE_NEXT = NOTE_IMAGE7 ;
										if(NOTE_X7 == 6 )begin  //last picture
//											X_PAGE_NEXT = NOTE_X7;
//											Y_NEXT = NOTE_Y7 ;
//											IMAGE_NEXT = NOTE_IMAGE7 ;
											NOTE_X7_NEXT = 0;
											//NOTE_Y7_NEXT = NOTE_Y7;
											NOTE_IMAGE7_NEXT = 6;
											I_valid_next = 3;
										end
										else if(NOTE_X7 == 4 )begin
//											X_PAGE_NEXT = NOTE_X7;
//											Y_NEXT = NOTE_Y7 ;
//											IMAGE_NEXT = NOTE_IMAGE7;
											NOTE_X7_NEXT = 6;
											//NOTE_Y7_NEXT = NOTE_Y7;
											NOTE_IMAGE7_NEXT = NOTE_IMAGE7;
											I_valid_next = con_one;
										end	
										else begin
//											X_PAGE_NEXT = NOTE_X7;
//											Y_NEXT = NOTE_Y7 ;
//											IMAGE_NEXT = NOTE_IMAGE7;
											NOTE_X7_NEXT = 4;
											//NOTE_Y7_NEXT = NOTE_Y7;
											NOTE_IMAGE7_NEXT = NOTE_IMAGE7;
											I_valid_next = con_one;
										end	
									end
								end
									
							end
							default:begin
								X_PAGE_NEXT = 0;
								Y_NEXT = 0 ;
								IMAGE_NEXT = 6;
								I_valid_next = 0;
							end
						endcase
						
						counter_next = counter +1;
						STATE_NEXT = Copy_Image;
						START_NEXT = re_start;
			
						//NEW_PAGE_NEXT = 1'b1;
						//PAGE_COUNTER_NEXT = 0;
						//COL_COUNTER_NEXT = 0;
						//INDEX_NEXT = 0;
					end
			end
			
			default: STATE_NEXT = Init;
		endcase
    end
	
	
	
/*******************************
 * Set PAC_MAN image patterns  *
 *******************************/
  always @(*)begin
	case (IMAGE)
		3'b000:	// 1st image note
			case (INDEX)
			  8'h00  :  PATTERN = 8'h00; // upper half of image
			  8'h01  :  PATTERN = 8'h00;
			  8'h02  :  PATTERN = 8'h00;
			  8'h03  :  PATTERN = 8'h00;
			  8'h04  :  PATTERN = 8'h00;
			  8'h05  :  PATTERN = 8'h00;
			  8'h06  :  PATTERN = 8'h00;
			  8'h07  :  PATTERN = 8'h00;    
			  8'h08  :  PATTERN = 8'h00; 
			  8'h09  :  PATTERN = 8'hFE;
			  8'h0A  :  PATTERN = 8'h36;
			  8'h0B  :  PATTERN = 8'h24;
			  8'h0C  :  PATTERN = 8'h48;
			  8'h0D  :  PATTERN = 8'h90;
			  8'h0E  :  PATTERN = 8'hA0;
			  8'h0F  :  PATTERN = 8'h00;
			  8'h10  :  PATTERN = 8'h00; // lower half of image
			  8'h11  :  PATTERN = 8'h38;
			  8'h12  :  PATTERN = 8'h7C;
			  8'h13  :  PATTERN = 8'h7C;
			  8'h14  :  PATTERN = 8'h7C;
			  8'h15  :  PATTERN = 8'h7C;
			  8'h16  :  PATTERN = 8'h7C;
			  8'h17  :  PATTERN = 8'h7C;  
			  8'h18  :  PATTERN = 8'h7C; 
			  8'h19  :  PATTERN = 8'h3F;
			  8'h1A  :  PATTERN = 8'h00;
			  8'h1B  :  PATTERN = 8'h00;
			  8'h1C  :  PATTERN = 8'h00;
			  8'h1D  :  PATTERN = 8'h00;
			  8'h1E  :  PATTERN = 8'h09;
			  8'h1F  :  PATTERN = 8'h00; 			  
			endcase
		3'b001:	// 2nd image funghi
			case (INDEX)
			  8'h00  :  PATTERN = 8'h00; // upper half of image
			  8'h01  :  PATTERN = 8'h38;
			  8'h02  :  PATTERN = 8'h60;
			  8'h03  :  PATTERN = 8'hF0;
			  8'h04  :  PATTERN = 8'hF8;
			  8'h05  :  PATTERN = 8'hF8;
			  8'h06  :  PATTERN = 8'hD4;
			  8'h07  :  PATTERN = 8'h94;  
			  8'h08  :  PATTERN = 8'h9C; 
			  8'h09  :  PATTERN = 8'h94;
			  8'h0A  :  PATTERN = 8'hD4;
			  8'h0B  :  PATTERN = 8'hFC;
			  8'h0C  :  PATTERN = 8'hF8;
			  8'h0D  :  PATTERN = 8'hF0;
			  8'h0E  :  PATTERN = 8'h60;
			  8'h0F  :  PATTERN = 8'h00;
			  8'h10  :  PATTERN = 8'h00; // lower half of image
			  8'h11  :  PATTERN = 8'h00;
			  8'h12  :  PATTERN = 8'h00;
			  8'h13  :  PATTERN = 8'h00;
			  8'h14  :  PATTERN = 8'h01;
			  8'h15  :  PATTERN = 8'h0F;
			  8'h16  :  PATTERN = 8'h3F;
			  8'h17  :  PATTERN = 8'h7F;  
			  8'h18  :  PATTERN = 8'h3F; 
			  8'h19  :  PATTERN = 8'h7F;
			  8'h1A  :  PATTERN = 8'h1F;
			  8'h1B  :  PATTERN = 8'h0F;
			  8'h1C  :  PATTERN = 8'h03;
			  8'h1D  :  PATTERN = 8'h06;
			  8'h1E  :  PATTERN = 8'h78;
			  8'h1F  :  PATTERN = 8'h00; 			  
			endcase 
		3'b010:	// 3nd image pacman
			case (INDEX)
			  8'h00  :  PATTERN = 8'h00; // upper half of image
			  8'h01  :  PATTERN = 8'hE0;
			  8'h02  :  PATTERN = 8'hF8;
			  8'h03  :  PATTERN = 8'hFC;
			  8'h04  :  PATTERN = 8'hFC;
			  8'h05  :  PATTERN = 8'hFE;
			  8'h06  :  PATTERN = 8'hFE;
			  8'h07  :  PATTERN = 8'hFE;  
			  8'h08  :  PATTERN = 8'h76; //
			  8'h09  :  PATTERN = 8'h62; //
			  8'h0A  :  PATTERN = 8'h76; //
			  8'h0B  :  PATTERN = 8'h7C;
			  8'h0C  :  PATTERN = 8'h3C;
			  8'h0D  :  PATTERN = 8'h38;
			  8'h0E  :  PATTERN = 8'h20;
			  8'h0F  :  PATTERN = 8'h00;
			  8'h10  :  PATTERN = 8'h00; // lower half of image
			  8'h11  :  PATTERN = 8'h03;
			  8'h12  :  PATTERN = 8'h0F;
			  8'h13  :  PATTERN = 8'h1F;
			  8'h14  :  PATTERN = 8'h1F;
			  8'h15  :  PATTERN = 8'h3F;
			  8'h16  :  PATTERN = 8'h3F;
			  8'h17  :  PATTERN = 8'h3F;  
			  8'h18  :  PATTERN = 8'h3F; 
			  8'h19  :  PATTERN = 8'h3F;
			  8'h1A  :  PATTERN = 8'h3F;
			  8'h1B  :  PATTERN = 8'h1F;
			  8'h1C  :  PATTERN = 8'h1E;
			  8'h1D  :  PATTERN = 8'h0E;
			  8'h1E  :  PATTERN = 8'h02;
			  8'h1F  :  PATTERN = 8'h00; 			  
			endcase 
		3'b011:	// 1st image note
			case (INDEX)
			  8'h00  :  PATTERN = 8'h00; // upper half of image
			  8'h01  :  PATTERN = 8'h00;
			  8'h02  :  PATTERN = 8'h00;
			  8'h03  :  PATTERN = 8'h00;
			  8'h04  :  PATTERN = 8'h00;
			  8'h05  :  PATTERN = 8'h00;
			  8'h06  :  PATTERN = 8'h00;
			  8'h07  :  PATTERN = 8'h00;    
			  8'h08  :  PATTERN = 8'h00; 
			  8'h09  :  PATTERN = 8'hFE;
			  8'h0A  :  PATTERN = 8'h36;
			  8'h0B  :  PATTERN = 8'h24;
			  8'h0C  :  PATTERN = 8'h48;
			  8'h0D  :  PATTERN = 8'h90;
			  8'h0E  :  PATTERN = 8'hA0;
			  8'h0F  :  PATTERN = 8'h00;
			  8'h10  :  PATTERN = 8'h00; // lower half of image
			  8'h11  :  PATTERN = 8'h38;
			  8'h12  :  PATTERN = 8'h7C;
			  8'h13  :  PATTERN = 8'h7C;
			  8'h14  :  PATTERN = 8'h7C;
			  8'h15  :  PATTERN = 8'h7C;
			  8'h16  :  PATTERN = 8'h7C;
			  8'h17  :  PATTERN = 8'h7C;  
			  8'h18  :  PATTERN = 8'h7C; 
			  8'h19  :  PATTERN = 8'h3F;
			  8'h1A  :  PATTERN = 8'h00;
			  8'h1B  :  PATTERN = 8'h00;
			  8'h1C  :  PATTERN = 8'h00;
			  8'h1D  :  PATTERN = 8'h00;
			  8'h1E  :  PATTERN = 8'h09;
			  8'h1F  :  PATTERN = 8'h00; 			  
			endcase
		default:	// 	
			case (INDEX)
			  default  :  PATTERN = 8'h00; // upper half of image	  
			endcase
	endcase	
  end

	
					
	
endmodule 