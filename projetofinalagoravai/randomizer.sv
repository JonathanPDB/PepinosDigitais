module randomizer (
  output int cardOrder[20] = -1    // put here the initial value
);

reg [7:0] LFSR = 255;
wire feedback;
parameter repetitions = 100;
parameter shifts = 10;
int randomFrom, randomTo;
int temp;
int a, b;

initial begin

	cardOrder = '{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19};
	
	for(int i=0; i<repetitions; i++) begin
	  for(int j=0; j<shifts; j++) begin		
		 feedback = LFSR[0] ^ LFSR[2] ^LFSR[3] ^ LFSR[4];
	    LFSR <= {LFSR[6:0],feedback};
	  end
	   
	  randomFrom = LFSR % 20;
	  
	  for(int j=0; j<shifts; j++) begin		
		 feedback = LFSR[0] ^ LFSR[2] ^LFSR[3] ^ LFSR[4];
	    LFSR <= {LFSR[6:0],feedback};
	  end
	  randomTo = LFSR % 20;
	  
	  temp = cardOrder[randomTo];
	  cardOrder[randomTo] = cardOrder[randomFrom];
	  cardOrder[randomFrom] = temp;
			
	end
end

endmodule