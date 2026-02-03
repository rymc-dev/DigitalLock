/* 
CodeControl 
This module is the key module for code control, we get input from code 
entry and utilize this internally based on the current mode we are in and 
we expect to happen.

inputs: 
	- ... 
	
outputs: 
	- ...
	
... 
*/

module CodeControl(
	input wire [1:0]mode,
	input wire code[15:0],
	input wire KEYA,
	input wire rst_n,
	input wire clk,
	output wire unlock
);
	/*
		code control is the module which controls the high level logic of the 
		digital lock system
		
		inputs: 
			- rst_n == SWX.H
	*/
	wire mode_decoder_enable_validate_to_enable_validate_unlock_logic;
	wire mode_decoder_enable_program_to_and_gate_a;
	wire code_equality_checker_to_unlock_logic_match;
	wire and_out;
	
	assign and_out = KEYA & mode_decoder_enable_validate_to_enable_validate_unlock_logic;
	
	current_code
	
	
	
	
	
endmodule

module CurrentCodeRegistry(
	input wire [15:0] code,
	input wire shift, 
	input wire rst_n,
	output wire [15:0] code
);
	/* 
		stores the current code 
		
		inputs: 
			... 
			
		outputs: 	
			...
	*/
endmodule

module ModeDecoder(
	input wire [1:0] mode, 
	output wire enable_validate,
	output wire enable_program
);
	/* 
		utilizes the current mode to determine what sort 
		of action we can perform
		
		inputs: 
			- ...
			
		outputs: 
			- ... 
	*/ 
	
	
endmodule


module CodeComparito(
	input wire a,
	input wire b,
	output wire match
);
	/* 
		compares both of the passwords to determine if they are 
		a match or not.
		
		inputs: 
			... 
			
		outputs: 
			... 
	*/

endmodule


module UnlockLogic(
	input wire enable_validate,
	input wire match,
	input wire trigger_validate,
	input wire clk,
	output wire unlock
);
	/* 
		contains unlock logic for the digital system
		
		inputs: 
		
			... 
			
		outputs: 
		
			... 
	*/ 


endmodule



