`default_nettype none `timescale 1ns / 1ps

// Receive 50 MHz clock and output a 25 MHz clock
module clock_25M_divider (
    input  wire logic clk_50m,  // input clock (50 MHz)
    input  wire logic rst,      // reset
    output logic      clk_out   // pixel clock
);

  initial clk_out = 0;

  always_ff @(posedge clk_50m) begin
    if (rst) clk_out = 0;
    else clk_out = ~clk_out;
  end
endmodule


module clock_25M_divider_tb;
  reg clk_50m, reset;
  wire clk_out;

  parameter stimDelay = 1;

  clock_25M_divider instancia_divisor (
      clk_50m,
      reset,
      clk_out
  );

  initial begin
    clk_50m = 0;
    forever begin
      #(stimDelay) clk_50m = ~clk_50m;
    end
  end

  initial begin
    clk_50m = 1;
    reset   = 1;
    #5 reset = 0;
  end
endmodule