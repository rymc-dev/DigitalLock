// =========================
// CodeEntry Module (Top Level)
// =========================
/*
    CodeEntry Module - Manages digit selection and code entry
    
    Sub-modules:
    - ModeChangeDetector: Detects mode transitions
    - DirectionLogic: Decodes up/down buttons
    - SinglePulse: Converts button press to single pulse
    - UpDownCounterWrap: Counts 0-9 for digit selection
    - CodeShiftRegister: Stores entered code with live preview
    
    Data Flow:
    1. KEYB/KEYC → DirectionLogic → valid signal
    2. valid → SinglePulse → single pulse per button press
    3. pulse → UpDownCounterWrap → digit selection (0-9)
    4. digit → CodeShiftRegister → live preview on display
    5. KEYD → CodeShiftRegister → lock digit and shift to next position
*/
module CodeEntry(
    input wire clk,                  // System clock
    input wire rst_n,                // Active-low reset
    input wire [1:0] current_mode,   // Current system mode
    input wire keyb_s,               // KEYB: Up button
    input wire keyc_s,               // KEYC: Down button
    input wire keyd_s,               // KEYD: Entry/shift button
    output wire [15:0] code          // 16-bit code output (4 digits)
);
    /*
        Top-level code entry module managing digit selection and entry.
        
        Operation Flow:
        1. User presses KEYB/KEYC to select digit (0-9)
        2. Selected digit shows on display (live preview)
        3. User presses KEYD to lock digit and move to next position
        4. Repeat for all 4 digits
        5. On mode change: reset counter and shift register
    */
    
    // ---- Internal Signal Declarations ----
    wire direction_valid;            // Valid button press indicator
    wire direction;                  // Direction: 1=up, 0=down
    wire count_pulse;                // Single pulse for counter increment/decrement
    wire [3:0] current_digit;        // Current digit selection (0-9)
    wire mode_changed;               // Mode change detection pulse
    
    // ---- Reset Signal Generation ----
    // Reset shift register on: global reset OR mode change
    wire shift_register_reset_n = rst_n & !mode_changed;
    
    // ---- Counter Clear Signal ----
    // Clear counter on: KEYD press (after shift) OR mode change
    wire counter_clear = keyd_s | mode_changed;
    
    // ---- Sub-Module Instantiations ----
    
    // Detect mode changes and generate reset pulse
    ModeChangeDetector mode_change_detector_inst(
        .clk(clk),
        .rst_n(rst_n), 
        .current_mode(current_mode),
        .is_mode_change(mode_changed)
    );
    
    // Decode up/down buttons into direction and validity
    DirectionLogic direction_logic_inst(
        .up(keyb_s),
        .down(keyc_s),
        .dir(direction),
        .valid(direction_valid)
    );
    
    // Convert button press into single-cycle pulse
    SinglePulse single_pulse_inst(
        .clk(clk),
        .rst_n(rst_n),
        .trigger(direction_valid),
        .pulse(count_pulse)
    );
    
    // Count up/down to select digit (0-9)
    UpDownCounterWrap up_down_counter_inst(
        .clk(clk),
        .rst_n(rst_n),
        .clear(counter_clear),
        .ud(direction),
        .trigger(count_pulse),
        .count(current_digit)
    );
    
    // Store digits and display code with live preview
    CodeShiftRegister code_shift_register_inst(
        .digit(current_digit),
        .rst_n(shift_register_reset_n),
        .shift(keyd_s),
        .clk(clk),
        .code(code)
    );
    
endmodule
