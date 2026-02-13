// =========================
// CodeControl Module (Top Level)
// =========================
module CodeControl(
    input wire [1:0] current_mode,   // Current system mode from ModeController
    input wire [15:0] current_code,  // Code being entered from CodeEntry
    input wire keya,                 // KEYA button (validate/program trigger)
    input wire rst_n,                // Active-low reset
    input wire clk,                  // System clock
    output wire unlock               // Unlock pulse output
);
    /*
        Top-level module for password validation and programming control.
        
        Architecture:
        1. ModeDecoder: Determines what operations are allowed
        2. CurrentCodeRegistry: Stores the password
        3. CodeEqualityChecker: Compares entered vs stored passwords
        4. UnlockLogic: Generates unlock pulse when validated
        
        Data Flow:
        - Mode → ModeDecoder → enable signals
        - KEYA + enable_program → Password storage trigger
        - current_code vs stored_code → match signal
        - match + enable_validate + KEYA → unlock pulse
    */
    
    // ---- Internal Signal Declarations ----
    wire enable_validate;            // Allow password validation (from ModeDecoder)
    wire enable_program;             // Allow password programming (from ModeDecoder)
    wire [15:0] stored_password;     // Current stored password (from Registry)
    wire password_match;             // Codes match indicator (from EqualityChecker)
    wire program_trigger;            // Combined trigger for programming
    
    // ---- Programming Trigger Logic ----
    // Store new password when KEYA pressed AND programming enabled
    assign program_trigger = keya & enable_program;
    
    // ---- Module Instantiations ----
    
    // Decode current mode to determine allowed operations
    ModeDecoder mode_decoder_inst(
        .mode(current_mode),
        .enable_validate(enable_validate),
        .enable_program(enable_program)
    );
    
    // Store and retrieve passwords
    CurrentCodeRegistry password_registry_inst(
        .code(current_code),
        .shift(program_trigger),
        .rst_n(rst_n),
        .clk(clk),
        .stored_code(stored_password)
    );
    
    // Compare entered code with stored password
    CodeEqualityChecker equality_checker_inst(
        .a(current_code),
        .b(stored_password),
        .match(password_match)
    );
    
    // Generate unlock pulse when validation succeeds
    UnlockLogic unlock_logic_inst(
        .enable_validate(enable_validate),
        .match(password_match),
        .trigger_validate(keya),
        .clk(clk),
        .rst_n(rst_n),
        .unlock(unlock)
    );
    
endmodule



