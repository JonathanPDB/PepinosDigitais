module debouncer (
	input logic 		clk,
	input int 			iterations,
	input logic 		noisy,
	output logic		debounced
);

	logic [iterations:0] register;

	//register: wait for stable speed
	always @ (posedge clk) 
		begin
			int shift = iterations - 1;
			register[iterations:0] <= {register[shift:0],noisy}; //shift register
		if(register[iterations:0] == 32'b0)	//if the bounce happened during shift, ignore it.
			debounced <= 1'b0;
		else if(register[iterations:0] == iterations'b1)	//if bounce happens after the shift,
			debounced <= 1'b1;	//pass the noisy value in.
		else debounced <= debounced;
	end

endmodule