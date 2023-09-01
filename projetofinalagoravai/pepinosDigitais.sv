`default_nettype none `timescale 10ns / 10ns

module pepinosDigitais (
  input  wire logic       clock_50M,
  output logic            vga_hsync,  // VGA horizontal sync
  output logic            vga_vsync,  // VGA vertical sync
  output logic      [9:0] vga_r,      // 10-bit VGA red
  output logic      [9:0] vga_g,      // 10-bit VGA green
  output logic      [9:0] vga_b,      // 10-bit VGA blue
  output logic            clock_25M,  // 25 MHz clock for the VGA DAC
  output logic            vga_blank,  // VGA DAC blank pin
  input logic				select,		 // botÃƒÂµes
  input wire logic				move_x,
  input wire logic				move_y
);
  parameter SCREEN_WIDTH = 10'd640;
  parameter SCREEN_HEIGHT = 10'd480;

  parameter COLOR_WHITE = 10'd1023;
  parameter COLOR_GRAY = 10'd512;
  parameter COLOR_BLACK = 10'd0;

  parameter COLOR_MAGENTA_r = 10'd1023;
  parameter COLOR_MAGENTA_g = 10'd0;
  parameter COLOR_MAGENTA_b = 10'd1023;

  parameter COLOR_CYAN_r = 10'd0;
  parameter COLOR_CYAN_g = 10'd1023;
  parameter COLOR_CYAN_b = 10'd1023;

  parameter COLOR_YELLOW_r = 10'd1023;
  parameter COLOR_YELLOW_g = 10'd1023;
  parameter COLOR_YELLOW_b = 10'd0;

  parameter COLOR_RED_r = 10'd1023;
  parameter COLOR_RED_g = 10'd0;
  parameter COLOR_RED_b = 10'd0;

  parameter COLOR_LIME_r = 10'd0;
  parameter COLOR_LIME_g = 10'd1023;
  parameter COLOR_LIME_b = 10'd0;

  parameter COLOR_BLUE_r = 10'd0;
  parameter COLOR_BLUE_g = 10'd0;
  parameter COLOR_BLUE_b = 10'd1023;

  parameter COLOR_ORANGE_r = 10'd1023;
  parameter COLOR_ORANGE_g = 10'd700;
  parameter COLOR_ORANGE_b = 10'd0;

  parameter COLOR_OLIVE_r = 10'd512;
  parameter COLOR_OLIVE_g = 10'd512;
  parameter COLOR_OLIVE_b = 10'd0;
  
  parameter COLOR_PURPLE_r = 10'd512;
  parameter COLOR_PURPLE_g = 10'd0;
  parameter COLOR_PURPLE_b = 10'd512;

  parameter COLOR_BROWN_r = 10'd680;
  parameter COLOR_BROWN_g = 10'd341;
  parameter COLOR_BROWN_b = 10'd0;

  parameter LARGURA_CARTA = 104;
  parameter ALTURA_CARTA = 95;
  parameter ESPACAMENTO_CARTAS = 20;
  parameter OFFSET = 26;

  logic isFlipped[20] = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  logic isOut[20] = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  int pos = 0;
  logic clock_1Hz = 0;
  logic gameOver = 0;
 

  integer POSX_CARTA[4:0] = '{20,144,268,392,516};
  integer POSY_CARTA[3:0] = '{20,135,250,365};

  clock_25M_divider inst_clock_25M (
    clock_50M,
    1'b0,
    clock_25M
  );
  
  clock_1Hz_divider inst_clock_1Hz (
    clock_50M,
    clock_1Hz
  );

  logic [9:0] sx;
  logic [9:0] sy;
  logic hsync, vsync, de;

  vga instancia_vga (
    clock_25M,
    1'b0,
    sx,
    sy,
    hsync,
    vsync,
    de
  );

	int cardOrder[20];

  logic frame;  // high for one clock tick at the start of vertical blanking
  always_comb frame = (sy == SCREEN_HEIGHT && sx == 0);

  initial begin
    vga_r = 10'h0;
    vga_g = 10'h0;
    vga_b = 10'h0;
    vga_hsync = 1'b1;
    vga_vsync = 1'b1;
    vga_blank = 1'b1;
  end


  logic [9:0] paint_r, paint_g, paint_b;
  int cardPos;
  always_comb begin

    paint_r = COLOR_BLACK;
    paint_g = COLOR_BLACK;
    paint_b = COLOR_BLACK;

    cardPos = 0;
    for(int i=0;i<5;i++) begin
      for(int j=0;j<4;j++) begin
        if (sx > POSX_CARTA[i] && sx < (POSX_CARTA[i]+LARGURA_CARTA) && sy > POSY_CARTA[j] && sy < (POSY_CARTA[j]+ALTURA_CARTA)) begin
          cardPos = 4*i +j;

          if(isOut[cardPos]) begin
            paint_r = COLOR_BLACK;
            paint_g = COLOR_BLACK;
            paint_b = COLOR_BLACK;
          end
          else if(!isFlipped[cardPos]) begin
            paint_r = COLOR_GRAY;
            paint_g = COLOR_GRAY;
            paint_b = COLOR_GRAY;
          end else begin 
            case(cardOrder[cardPos])
              0, 1: begin
                paint_r = COLOR_LIME_r;
                paint_g = COLOR_LIME_g;
                paint_b = COLOR_LIME_b;
              end 
              2, 3: begin
                paint_r = COLOR_MAGENTA_r;
                paint_g = COLOR_MAGENTA_g;
                paint_b = COLOR_MAGENTA_b;
              end 
              4, 5: begin
                paint_r = COLOR_RED_r;
                paint_g = COLOR_RED_g;
                paint_b = COLOR_RED_b;
              end 
              6, 7: begin
                paint_r = COLOR_BLUE_r;
                paint_g = COLOR_BLUE_g;
                paint_b = COLOR_BLUE_b;
              end 
              8, 9: begin
                paint_r = COLOR_CYAN_r;
                paint_g = COLOR_CYAN_g;
                paint_b = COLOR_CYAN_b;
              end 
              10, 11: begin
                paint_r = COLOR_YELLOW_r;
                paint_g = COLOR_YELLOW_g;
                paint_b = COLOR_YELLOW_b;
              end 
              12, 13: begin
                paint_r = COLOR_ORANGE_r;
                paint_g = COLOR_ORANGE_g;
                paint_b = COLOR_ORANGE_b;
              end 
              14, 15: begin
                paint_r = COLOR_OLIVE_r;
                paint_g = COLOR_OLIVE_g;
                paint_b = COLOR_OLIVE_b;
              end 
              16, 17: begin
                paint_r = COLOR_PURPLE_r;
                paint_g = COLOR_PURPLE_g;
                paint_b = COLOR_PURPLE_b;
              end 
              18, 19: begin
                paint_r = COLOR_BROWN_r;
                paint_g = COLOR_BROWN_g;
                paint_b = COLOR_BROWN_b;
              end 
              default: begin
                paint_r = COLOR_BLACK;
                paint_g = COLOR_BLACK;
                paint_b = COLOR_BLACK;
              end 
            endcase
          end	

          if(cardPos == pos) begin
            if (sx > (POSX_CARTA[i]+OFFSET) && sx < (POSX_CARTA[i]+LARGURA_CARTA-OFFSET) && sy > (POSY_CARTA[j]+OFFSET) && sy < (POSY_CARTA[j]+ALTURA_CARTA-OFFSET)) begin
              paint_r = COLOR_WHITE;
              paint_g = COLOR_WHITE;
              paint_b = COLOR_WHITE;
            end
          end

        end
      end
    end
  end


  always_ff @ (posedge clock_1Hz) begin
    if (!move_y) begin
      if(((pos+1) % 4) == 0)
        pos = pos - 3;
      else
        pos++;
    end

    if (!move_x) begin
      if(pos < 4)
        pos = pos + 16;
      else
        pos = pos - 4;
    end
  end

  int cardsFlipped[2];
  int numberOfCardsFlipped = 0;
  logic gameOverFlag = 0;
  
  logic flag = 1;  
  int k;
  int temp;
  int seed = 0;
  
  always_ff @ (negedge select) begin
    if(flag) begin
		cardOrder = '{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19};
	   for(int i=19; i > 0; i--) begin
		  k = seed % (i + 1);
		  temp = cardOrder[i];
		  cardOrder[i] = cardOrder[k];
		  cardOrder[k] = temp;
		end
	   flag = 0;
	 end
	
    if(numberOfCardsFlipped == 2) begin
	   isFlipped = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
		if(cardOrder[cardsFlipped[0]] % 2) begin
		    if((cardOrder[cardsFlipped[0]] - 1) == cardOrder[cardsFlipped[1]]) begin
				 isOut[cardsFlipped[0]] = 1;
				 isOut[cardsFlipped[1]] = 1;
			 end
		  end
		  else begin
		    if((cardOrder[cardsFlipped[0]] + 1) == cardOrder[cardsFlipped[1]]) begin
				 isOut[cardsFlipped[0]] = 1;
				 isOut[cardsFlipped[1]] = 1;
			 end
		  end
	 end
	 
	 numberOfCardsFlipped = 0;
	 cardsFlipped = '{0,0};
  
    if(!isFlipped[pos] && !isOut[pos]) begin 
      isFlipped[pos] = 1;

      for(int i=0; i<20; i++) begin
        if(isFlipped[i]) begin 
          cardsFlipped[numberOfCardsFlipped] = i;//[0] = 0    [1] = 3
          numberOfCardsFlipped ++;
        end
      end
    end
	 
	 gameOverFlag = 1;
	 for(int i=0; i<20; i++) begin
	   if(!isOut[i]) begin
			gameOverFlag = 0;
			break;
		end
	 end
			
	 if(gameOverFlag) begin
	   isOut =  '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	   isFlipped = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	 end

  end


  // VGA signal output
  always_ff @(posedge clock_25M) begin
    seed++;
	 
    vga_hsync = hsync;
    vga_vsync = vsync;

    if (de) begin
      vga_r = paint_r;
      vga_g = paint_g;
      vga_b = paint_b;
    end else begin  // VGA colour should be black in blanking interval
      vga_r = 10'h0;
      vga_g = 10'h0;
      vga_b = 10'h0;
    end
  end

  
endmodule
