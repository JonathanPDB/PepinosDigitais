`default_nettype none `timescale 10ns / 10ns

module pepinosDigitais (
    input  wire logic       clock_50M,
    output logic            vga_hsync,  // VGA horizontal sync
    output logic            vga_vsync,  // VGA vertical sync
    output logic      [9:0] vga_r,      // 10-bit VGA red
    output logic      [9:0] vga_g,      // 10-bit VGA green
    output logic      [9:0] vga_b,      // 10-bit VGA blue
    output logic            clock_25M,  // 25 MHz clock for the VGA DAC
    output logic            vga_blank   // VGA DAC blank pin
);
  parameter SCREEN_WIDTH = 10'd640;
  parameter SCREEN_HEIGHT = 10'd480;

  parameter COLOR_WHITE = 10'd1023;
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
	
	parameter LARGURA_CARTA = 104;
	parameter ALTURA_CARTA = 95;
	parameter ESPACAMENTO_CARTAS = 20;
	//parameter matriz_cartas[5][4];
	
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

  
  always_comb begin
  
   paint_r = COLOR_BLACK;
	paint_g = COLOR_BLACK;
	paint_b = COLOR_BLACK;
			
  for(int i=0;i<5;i++) begin
	for(int j=0;j<4;j++) begin
		if (sx > POSX_CARTA[i] && sx < (POSX_CARTA[i]+LARGURA_CARTA) && sy > POSY_CARTA[j] && sy < (POSY_CARTA[j]+ALTURA_CARTA)) begin
			paint_r = COLOR_MAGENTA_r;
			paint_g = COLOR_MAGENTA_g;
			paint_b = COLOR_MAGENTA_b;
			
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

