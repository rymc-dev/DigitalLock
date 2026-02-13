// =========================
// DigitalLockSystem - Top Level Module
// =========================
/** 
    Digital FPGA design for an electronic safe locking system.
    
    System Overview:
    This is the top-level module that integrates three main sub-systems:
    1. ModeController - Manages system states (LOCKED/UNLOCKED/PROGRAMMING)
    2. CodeEntry - Handles digit selection and code entry
    3. CodeControl - Validates passwords and controls unlocking
    
    Hardware Interface:
    - Inputs: DE2 board buttons and switches (active-low)
    - Outputs: LEDs (active-high) and 7-segment display code
    - Clock: 50MHz system clock from DE2 board
    
    Operation:
    1. User enters 4-digit code using KEYB/KEYC (up/down) and KEYD (enter)
    2. System validates code against stored password
    3. Correct code unlocks system (green LED)
    4. Programming mode allows changing password when unlocked
**/
module DigitalLockSystem(
    // ---- Input Ports ----
    input  swx_n,        // System reset (active-low) - SW[17] on DE2
    input  swm,          // Mode switch (active-low) - SW[16] on DE2
    input  keya,         // KEY A: Lock/Restart button (active-low) - KEY[0]
    input  keyb,         // KEY B: Up button (active-low) - KEY[1]
    input  keyc,         // KEY C: Down button (active-low) - KEY[2]
    input  keyd,         // KEY D: Enter button (active-low) - KEY[3]
    input  clk,          // System clock - 50MHz from DE2 board
    
    // ---- Output Ports ----
    output rledx,        // Red LED - locked indicator (active-high)
    output gledx,        // Green LED - unlocked indicator (active-high)
    output [15:0] hexx_y // 16-bit code for 7-segment display (4 digits × 4 bits)
);
    /*
        Top-level integration module connecting all sub-systems.
        
        Signal Flow:
        1. Buttons/switches → Active-low to active-high conversion
        2. Mode control → ModeController FSM
        3. Code entry → CodeEntry system
        4. Validation → CodeControl system
        5. Unlock signal → Back to ModeController
        
        All internal logic operates on active-high signals for consistency.
    */
    
    // ---- Internal Signal Declarations ----
    wire unlock_signal;      // Unlock pulse from CodeControl to ModeController
    wire [1:0] mode_signal;  // Current system mode (from ModeController to others)
    
    // ---- Active-Low to Active-High Conversion ----
    // DE2 board buttons and switches are active-low (pressed = 0, released = 1)
    // Internal logic uses active-high (pressed = 1, released = 0) for clarity
    wire swm_int  = ~swm;    // Invert mode switch
    wire keya_int = ~keya;   // Invert KEYA button
    wire keyb_int = ~keyb;   // Invert KEYB button (up)
    wire keyc_int = ~keyc;   // Invert KEYC button (down)
    wire keyd_int = ~keyd;   // Invert KEYD button (enter)
    
    // -----------------------------
    // Sub-Module Instantiations
    // -----------------------------
    
    // ---- ModeController Instance ----
    // Manages system FSM: LOCKED → UNLOCKED → UNLOCKED_PROGRAMMING
    // Controls LED outputs based on current state
    ModeController mode_controller_inst (
        .unlock (unlock_signal),  // Input: unlock pulse from CodeControl
        .swx_n  (swx_n),          // Input: system reset (active-low, not inverted)
        .swm    (swm_int),        // Input: mode switch (active-high converted)
        .keya   (keya_int),       // Input: lock button (active-high converted)
        .clk    (clk),            // Input: system clock
        .rledx  (rledx),          // Output: red LED (locked indicator)
        .gledx  (gledx),          // Output: green LED (unlocked indicator)
        .mode   (mode_signal)     // Output: current mode to other modules
    );
    
    // ---- CodeEntry Instance ----
    // Handles digit selection (0-9) and code entry
    // Outputs 16-bit code representing 4 entered digits
    CodeEntry code_entry_inst (
        .clk(clk),                    // Input: system clock
        .rst_n(swx_n),                // Input: reset (active-low, not inverted)
        .current_mode(mode_signal),   // Input: current system mode
        .keyb_s(keyb_int),            // Input: up button (active-high converted)
        .keyc_s(keyc_int),            // Input: down button (active-high converted)
        .keyd_s(keyd_int),            // Input: enter button (active-high converted)
        .code(hexx_y)                 // Output: 16-bit code to display and validation
    );
    
    // ---- CodeControl Instance ----
    // Validates entered code against stored password
    // Generates unlock pulse when correct code entered in LOCKED mode
    // Stores new password when KEYA pressed in PROGRAMMING mode
    CodeControl code_control_inst(
        .current_mode(mode_signal),   // Input: current system mode
        .current_code(hexx_y),        // Input: code from CodeEntry
        .keya(keya_int),              // Input: validation/program trigger (active-high)
        .rst_n(swx_n),                // Input: reset (active-low, not inverted)
        .clk(clk),                    // Input: system clock
        .unlock(unlock_signal)        // Output: unlock pulse to ModeController
    );
    
endmodule