module cardPair(
	input int card1Pos,
	input int card2Pos,
	
	output logic outOfGame,
	
	input logic unselectAll,
	input int selectPos,
);


	logic isOutOfGame = 0;
	logic isCard1Flipped = 0,
	logic isCard2Flipped = 0,

	always_comb begin
		if (selectPos == card1Pos && !isCard1Flipped && !isOutOfGame)
			isCard1Flipped = 1;
		
		if (selectPos == card2Pos && !isCard1Flipped && !isOutOfGame)  
			isCard2Flipped = 1;
		
		if (unselectAll) begin
			isCard1Flipped = 0;
			isCard2Flipped = 0;
		end
		
		if (isCard1Flipped && isCard2Flipped) begin
			isOutOfGame = 1;
			outOfGame = 1;
		end
			
	end

endmodule