
// Receive 50 MHz clock and output a 25 MHz clock
module clock_1Hz_divider (
    input  wire logic clk_50m,  // input clock (50 MHz)
    output logic      clk_out   // pixel clock
);

  initial clk_out = 0;
  longint count = 0;
  
  always_ff @(posedge clk_50m) begin
	 count++;
	 if (count == 4000000) begin
		clk_out = ~clk_out;
		count = 0;
	 end 
  end
endmodule

