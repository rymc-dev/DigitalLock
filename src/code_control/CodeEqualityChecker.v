module CodeEqualityChecker(
	input wire [15:0] a,
	input wire [15:0] b,
	output wire match
);
	/* 
		compares both of the passwords to determine if they are 
		a match or not.
		
		inputs: 
			- a: first 16-bit code (current entered code)
			- b: second 16-bit code (stored password)
			
		outputs: 
			- match: high if a equals b, low otherwise
	*/
	
	assign match = (a == b) ? 1'b1 : 1'b0;
endmodule