module DirectionLogic(
	input up,
	input down,
	output reg dir,
	output reg valid
);
	/* 
		Truth table which continuously outputs
		direction inputted from buttons for up/down
		counter as well as if the output is valid
	*/

	localparam DIR_UP = 1'b1;
	localparam DIR_DOWN = 1'b0;
	
	localparam IS_VALID = 1'b1;
	localparam NOT_VALID = 1'b0;
	
	always @(*) begin
		casex({up, down})
			2'b00: begin
				dir = 1'b0;
				valid = NOT_VALID;
			end
			2'b01: begin
				dir = DIR_DOWN;
				valid = IS_VALID;
			end
			2'b10: begin
				dir = DIR_UP;
				valid = IS_VALID;
			end
			2'b11: begin
				dir = 1'b0;
				valid = NOT_VALID;
			end
			default: begin
				dir = 1'b0;
				valid = NOT_VALID;
			end
		endcase
	end
endmodule