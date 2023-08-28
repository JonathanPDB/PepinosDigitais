module randomOrderGen(
  output int cardOrder[20] = -1    // put here the initial value
);

reg [7:0] LFSR = 255;
wire feedback = LFSR[7];
int repetitions = 100;

function reg[4:0] random() begin
	for(int i=0; i<repetitions; i++) begin		
		LFSR[0] <= feedback;
		LFSR[1] <= LFSR[0];
		LFSR[2] <= LFSR[1] ^ feedback;
		LFSR[3] <= LFSR[2] ^ feedback;
		LFSR[4] <= LFSR[3] ^ feedback;
		LFSR[5] <= LFSR[4];
		LFSR[6] <= LFSR[5];
		LFSR[7] <= LFSR[6];
	end
	return LFSR;
end


initial begin
	for(int i=0; i<20; i++) begin
		
		int randomInt; 
		logic validNumber = 0;
		
		
		do begin
			validNumber = 1;
		
			randomInt = 'int(random())
			
			if(randomInt > 19)
				validNumber = 0;
			else begin
				for(int j=0; j<20; j++) begin
					if (cardOrder[j] == randomInt) begin
						validNumber = 0;
						break;
					end
				end	
			end
		end while (!validNumber);

		cardOrder[i] = randomInt;
	end
end

endmodule