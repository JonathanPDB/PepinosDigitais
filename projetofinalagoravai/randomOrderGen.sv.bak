module randomOrderGen(
	output int [20] cardOrder;
);

	int randomIterations;
	
	initial begin
		randomIterations = 100;
	
		for (int i = 0; i < 20; i++)
			cardOrder[i] = i;
		
		for (int i = 0; i < 100; i++) begin
			randomIndexFrom = $urandom_range(20);
			randomIndexTo = $urandom_range(20);
			cardOrder[randomIndexTo] = cardOrder[randomIndexFrom]
		end
endmodule