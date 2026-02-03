module ModeController(
	output RLEDX,
	output GLEDX,
	output mode,
	input SWX,
	input unlock,
	input KEYA,
	input SWM,
	input clk
);
	/*
	Mode Controller ASM determines the safes current access
	level & updates the associated lock indicators as expected
	
	ASM Formal Definition: (q0, Q, T) 
	q0: UNLOCKED
	Q: {LOCKED, UNLOCKED, UNLOCKED_PROGRAMMING}
	T: # Transitions aka delta
	
	inputs: 
		- SWX: System Reset button moves system back to the initial discrete state 
				 SWX
		- SWM: Switch Mode button which works in unlocked super state moves between 
				 programming mode and standard lock mode
		- unlock: valid code entry input 
	outputs: 
		- 
	*/

	// state encodings
	parameter LOCKED = 2'b00;
	parameter UNLOCKED = 2'b01;
	parameter UNLOCKED_PROGRAMMING = 2'b10;
	
	// current and next state encodings
	reg [1:0] current_state = LOCKED;
	reg [1:0] next_state = state;
	
	// state register 
	always @(posedge clk or nededge SWX)
		if (!SWX) 
			current_state <= LOCKED;
			mode <= current_state;
		else: 
			current_state <= next_state;
			mode <= current_state;
			
		case (current_state)
			LOCKED: begin
				RLEDX <= 1'b1;
				GLEDX <= 1'b0;
			end
			UNLOCKED: begin 
				RLEDX <= 1'b1;
				GLEDX <= 1'b0;
			end
			UNLOCKED_PROGRAMMING: begin
				GLEDX <= 1'b1;
				RLEDX <= 1'b0;
			end
		endcase
	end
	
	// Conditional Logic
	always @(*) 
		case (current_state)
			LOCKED: begin
				if (unlock): begin
					next_state = UNLOCKED;
				end
				else: begin 
					next_state = LOCKED;
				end
			end
			
			UNLOCKED: begin
				if (SWM): begin
					next_state = UNLOCKED_PROGRAMMING;
				end
				else: begin
					next_state = UNLOCKED;
				end
			end
			
			UNLOCKED_PROGRAMMING: begin
				if (SWM): begin
					next_state = UNLOCKED;
				end
				else: begin
					next_state = UNLOCKED_PROGRAMMING;
				end
			end
			
			default: begin
				next_state = LOCKED;
			end
		endcase
	end
endmodule