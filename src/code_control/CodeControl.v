// =========================
// Code Control Sub Module 
// =========================
/* 
CodeControl 
This module is the key module for code control, we get input from code 
entry and utilize this internally based on the current mode we are in and 
we expect to happen.

Based on the diagram:
- ModeDecoder generates enable_validate and enable_program based on current mode
- CurrentCodeRegistry stores the programmed password (default 4'd2019)
- CodeEqualityChecker compares current_code with stored password
- UnlockLogic combines enable_validate, match signal, and keya trigger to unlock
*/

module CodeControl(
	input wire [1:0] current_mode,
	input wire [15:0] current_code,
	input wire keya,
	input wire rst_n,
	input wire clk,
	output wire unlock
);
	/*
		code control is the module which controls the high level logic of the 
		digital lock system
		
		inputs: 
			- current_mode: 2-bit mode from ModeController
			- current_code: 16-bit code from CodeEntry
			- keya: key A button (used as trigger for validation)
			- rst_n: active-low reset (SWX_N)
			- clk: system clock
			
		outputs:
			- unlock: signal to unlock the system
	*/
	
	// Internal wires
	wire mode_decoder_enable_validate;
	wire mode_decoder_enable_program;
	wire [15:0] stored_password;
	wire code_equality_match;
	wire and_gate_output;
	
	// AND gate: keya & enable_program -> shift signal for password registry
	assign and_gate_output = keya & mode_decoder_enable_program;
	
	// Instantiate ModeDecoder
	ModeDecoder mode_decoder_inst(
		.mode(current_mode),
		.enable_validate(mode_decoder_enable_validate),
		.enable_program(mode_decoder_enable_program)
	);
	
	// Instantiate CurrentCodeRegistry (stores programmed password)
	CurrentCodeRegistry current_code_registry_inst(
		.code(current_code),
		.shift(and_gate_output),
		.rst_n(rst_n),
		.clk(clk),
		.stored_code(stored_password)
	);
	
	// Instantiate CodeEqualityChecker (16-bit comparator)
	CodeEqualityChecker code_equality_checker_inst(
		.a(current_code),
		.b(stored_password),
		.match(code_equality_match)
	);
	
	// Instantiate UnlockLogic
	UnlockLogic unlock_logic_inst(
		.enable_validate(mode_decoder_enable_validate),
		.match(code_equality_match),
		.trigger_validate(keya),
		.clk(clk),
		.rst_n(rst_n),
		.unlock(unlock)
	);
endmodule





