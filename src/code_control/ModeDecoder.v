module ModeDecoder(
	input wire [1:0] mode, 
	output reg enable_validate,
	output reg enable_program
);
	/* 
		utilizes the current mode to determine what sort 
		of action we can perform
		
		Mode encoding:
		- 2'b00: LOCKED - no validation or programming
		- 2'b01: UNLOCKED - can validate (re-lock)
		- 2'b10: UNLOCKED_PROGRAMMING - can program new password
		
		inputs: 
			- mode: 2-bit mode signal
			
		outputs: 
			- enable_validate: high when in UNLOCKED mode (can validate code)
			- enable_program: high when in UNLOCKED_PROGRAMMING mode
	*/ 
	
	localparam LOCKED = 2'b00;
	localparam UNLOCKED = 2'b01;
	localparam UNLOCKED_PROGRAMMING = 2'b10;
	
	always @(*) begin
		// Default outputs
		enable_validate = 1'b0;
		enable_program = 1'b0;
		
		case(mode)
			LOCKED: begin
				enable_validate = 1'b1;  // Can attempt to unlock
				enable_program = 1'b0;
			end
			
			UNLOCKED: begin
				enable_validate = 1'b1;  // Can re-lock
				enable_program = 1'b0;
			end
			
			UNLOCKED_PROGRAMMING: begin
				enable_validate = 1'b0;
				enable_program = 1'b1;   // Can program new password
			end
			
			default: begin
				enable_validate = 1'b0;
				enable_program = 1'b0;
			end
		endcase
	end
	
endmodule