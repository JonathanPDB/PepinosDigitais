
module ProjetoFinal (
	
	// Clock
   input  wire logic       clock_50M,
	
	// Buttons
	input logic 				rightButton,
	input logic 				leftButton,
	input logic 				upButton,
	input logic 				downButton,
	input logic 				selectButton,
	
	// VGA vars
   output logic            vga_hsync,  // VGA horizontal sync
   output logic            vga_vsync,  // VGA vertical sync
   output logic      [9:0] vga_r,      // 10-bit VGA red
   output logic      [9:0] vga_g,      // 10-bit VGA green
   output logic      [9:0] vga_b,      // 10-bit VGA blue
   output logic            clock_25M,  // 25 MHz clock for the VGA DAC
	output logic            vga_blank   // VGA DAC blank pin
);


	parameter DEBOUNCE_ITERATIONS = 32;

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
	
	int [20] order;
	randomOrderGen randomOrderGenInst (
		order
	);
	
	
	logic right, left, up, down, select;
	debouncer debounce_right (
		clock_50M,
		DEBOUNCE_ITERATIONS,
		rightButton,
		right
	);
	
	debouncer debounce_left(
		clock_50M,
		DEBOUNCE_ITERATIONS,
		leftButton,
		left
	);
	
	debouncer debounce_up (
		clock_50M,
		DEBOUNCE_ITERATIONS,
		upButton,
		up
	);
	
	debouncer debounce_down (
		clock_50M,
		DEBOUNCE_ITERATIONS,
		downButton,
		down
	);
	
	debouncer debounce_select (
		clock_50M,
		DEBOUNCE_ITERATIONS,
		selectButton,
		select
	);
	
	
	logic isOutOfGame[10];
	
	
	cardPair card_pair[10] (
		.cardPos1,
		.cardPos2,
		.isCard1Flipped,
		.isCard2Flipped,
		.isOutOfGame,
		.select,
		.unselectAll,
	);
	
	
	
	initial begin
		vga_r = COLOR_BLACK;
		vga_g = COLOR_BLACK;
		vga_b = COLOR_BLACK;
		vga_hsync = 1'b1;
		vga_vsync = 1'b1;
		vga_blank = 1'b1;
	end
	
	
	
	logic frame;  // high for one clock tick at the start of vertical blanking
	always_comb frame = (sy == SCREEN_HEIGHT && sx == 0);
	
	int gridPosX = 0;
	int gridPosY = 0;
	parameter GRID_SIZE_X = 5; 
	parameter GRID_SIZE_Y = 4; 
	
	always_ff @ (posedge clock_25M) begin
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

		if (frame) begin
			if (right && (gridPosX < GRID_SIZE_X)) gridPosX++;
			if (left  && (gridPosX > 0)) 				gridPosX--;
			if (up    && (gridPosY > 0)) 				gridPosY++;
			if (down  && (gridPosY < GRID_SIZE_Y)) gridPosY--;
		end
	
	end
	


endmodule