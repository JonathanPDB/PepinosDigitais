module randomizer (
  output int cardOrder[20] = -1    // put here the initial value
);

reg [7:0] LFSR = 255;
wire feedback;
parameter repetitions = 100;
parameter maxTries = 200;


initial begin
	for(int i=0; i<20; i++) begin
		
		int randomInt; 
		logic validNumber = 0;
		int counter = 0;
		
		for(int k=0; k<maxTries; k++) begin
			validNumber = 1;
			
			for(int i=0; i<repetitions; i++) begin		
				feedback = LFSR[0] ^ LFSR[2] ^LFSR[3] ^ LFSR[4];
				LFSR <= {LFSR[6:0],feedback};
			end
	
			randomInt = LFSR % 20;
			
			for(int j=0; j<20; j++) begin
				if (cardOrder[j] == randomInt) begin
					validNumber = 0;
					break;
				end
			end	
			
			
			if(validNumber)
				break;
			
		end

		cardOrder[i] = randomInt;
	end
end

endmodule