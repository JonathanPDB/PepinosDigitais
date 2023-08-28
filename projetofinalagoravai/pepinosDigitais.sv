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
  input logic				  select,	  // botões
  input wire logic		  move_x,
  input wire logic		  move_y
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

  integer PAR_CARTAS_1[2:0] = '{COLOR_CYAN_r, COLOR_CYAN_g, COLOR_CYAN_b};
  integer PAR_CARTAS_2[2:0] = '{COLOR_YELLOW_r, COLOR_YELLOW_g, COLOR_YELLOW_b};
  integer PAR_CARTAS_3[2:0] = '{COLOR_MAGENTA_r, COLOR_MAGENTA_g, COLOR_MAGENTA_b};
  integer PAR_CARTAS_4[2:0] = '{COLOR_RED_r, COLOR_RED_g, COLOR_RED_b};
  integer PAR_CARTAS_5[2:0] = '{COLOR_LIME_r, COLOR_LIME_g, COLOR_LIME_b};
  integer PAR_CARTAS_6[2:0] = '{COLOR_BLUE_r, COLOR_BLUE_g, COLOR_BLUE_b};
  integer PAR_CARTAS_7[2:0] = '{COLOR_CYAN_r, COLOR_CYAN_g, COLOR_CYAN_b};
  integer PAR_CARTAS_8[2:0] = '{COLOR_CYAN_r, COLOR_CYAN_g, COLOR_CYAN_b};
  integer PAR_CARTAS_9[2:0] = '{COLOR_CYAN_r, COLOR_CYAN_g, COLOR_CYAN_b};
  integer PAR_CARTAS_10[2:0] = '{COLOR_CYAN_r, COLOR_CYAN_g, COLOR_CYAN_b};

  integer CARTAS[9:0][2:0];
  integer PAINTING;

  integer POSX_CARTA[4:0] = '{20,144,268,392,516};
  integer POSY_CARTA[3:0] = '{20,135,250,365};

  clock_25M_divider inst_clock_25M (
    clock_50M,
    1'b0,
    clock_25M
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


  int cardOrder[20] = '{7, 4, 16, 6, 18, 19, 5, 17, 2, 0, 10, 9, 12, 8, 11, 3, 1, 13, 15, 14};
  //	randomizer instancia_randomizer (
  //		cardOrder
  //	);



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

    //	CARTAS[0][2:0] = '{COLOR_CYAN_r, COLOR_CYAN_g, COLOR_CYAN_b};
    //	CARTAS[1][2:0] = '{COLOR_YELLOW_r, COLOR_YELLOW_g, COLOR_YELLOW_b};
    //	CARTAS[2][2:0] = '{COLOR_MAGENTA_r, COLOR_MAGENTA_g, COLOR_MAGENTA_b};
    //	CARTAS[3][2:0] = '{COLOR_BLUE_r, COLOR_BLUE_g, COLOR_BLUE_b};
    //	CARTAS[4][2:0] = '{COLOR_LIME_r, COLOR_LIME_g, COLOR_LIME_b};
    //	CARTAS[5][2:0] = '{COLOR_RED_r, COLOR_RED_g, COLOR_RED_b};
    //	CARTAS[6][2:0] = '{COLOR_RED_r, COLOR_RED_g, COLOR_RED_b};
    //	CARTAS[7][2:0] = '{COLOR_RED_r, COLOR_RED_g, COLOR_RED_b};
    //	CARTAS[8][2:0] = '{COLOR_RED_r, COLOR_RED_g, COLOR_RED_b};
    //	CARTAS[9][2:0] = '{COLOR_RED_r, COLOR_RED_g, COLOR_RED_b};

    PAINTING = 0;
    //  for(int i=0;i<5;i++) begin
    //	for(int j=0;j<4;j++) begin
    //		if (sx > POSX_CARTA[i] && sx < (POSX_CARTA[i]+LARGURA_CARTA) && sy > POSY_CARTA[j] && sy < (POSY_CARTA[j]+ALTURA_CARTA)) begin
    //			paint_r = COLOR_WHITE;
    //			paint_g = COLOR_WHITE;
    //			paint_b = COLOR_WHITE;
    //			
    //		end 
    //	end
    //  end

    cardPos = 0;
    for(int i=0;i<5;i++) begin
      for(int j=0;j<4;j++) begin
        if (sx > POSX_CARTA[i] && sx < (POSX_CARTA[i]+LARGURA_CARTA) && sy > POSY_CARTA[j] && sy < (POSY_CARTA[j]+ALTURA_CARTA)) begin
          cardPos = 4*i +j;


          if(isOut[cardOrder[cardPos]]) begin
            paint_r = COLOR_BLACK;
            paint_g = COLOR_BLACK;
            paint_b = COLOR_BLACK;
          end
          else if(!isFlipped[cardOrder[cardPos]]) begin
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
      //PAINTING = PAINTING+4;

    end
  end

  always_ff @ (negedge move_x or negedge move_y) begin
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
  int numberOfCardsFlipped;
  always_ff @ (negedge select) begin
    if(!isFlipped[pos] && !isOut[pos]) begin 
      isFlipped[pos] = 1;

      cardsFlipped = '{0,0};
      numberOfCardsFlipped = 0;
      for(int i=0; i<20; i++) begin
        if(isFlipped[i]) begin 
          cardsFlipped[numberOfCardsFlipped] = i;
          numberOfCardsFlipped ++;
        end
      end

      if(numberOfCardsFlipped >= 2) begin
        if((cardsFlipped[0] + 1) == cardsFlipped[1]) begin
          isOut[cardsFlipped[0]] = 1;
          isOut[cardsFlipped[1]] = 1;
          isFlipped[cardsFlipped[0]] = 0;
          isFlipped[cardsFlipped[1]] = 0;
        end
      end
    end

  end


  // VGA signal output
  always_ff @(posedge clock_25M) begin
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

