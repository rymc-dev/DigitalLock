// =========================
// UnlockLogic Module
// =========================
module UnlockLogic(
    input wire enable_validate,      // Enable signal from ModeDecoder
    input wire match,                 // Password match signal from CodeEqualityChecker
    input wire trigger_validate,     // KEYA button input
    input wire clk,                   // System clock
    input wire rst_n,                 // Active-low reset
    output reg unlock                 // Single-cycle unlock pulse output
);
    /* 
        Generates a single-clock pulse to unlock the system when:
        1. Validation is enabled (in LOCKED or UNLOCKED mode)
        2. Entered code matches stored password
        3. KEYA button is pressed (rising edge detected)
        
        This module uses edge detection to ensure unlock only pulses
        once per button press, preventing unintended state changes.
    */
    
    // ---- Edge Detection Registers ----
    reg trigger_validate_delayed;    // Previous state of trigger_validate
    wire trigger_rising_edge;        // Rising edge detection signal
    
    // Detect rising edge of trigger_validate (button press)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            trigger_validate_delayed <= 1'b0;
        else
            trigger_validate_delayed <= trigger_validate;  // Store previous state
    end
    
    // Rising edge occurs when current is high and previous was low
    assign trigger_rising_edge = trigger_validate & ~trigger_validate_delayed;
    
    // ---- Unlock Pulse Generation ----
    // Generate single-cycle unlock pulse when all conditions met
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            unlock <= 1'b0;  // Reset to locked state
        end
        else begin
            // Unlock for ONE clock cycle if:
            // - Validation is enabled AND
            // - Passwords match AND
            // - KEYA button rising edge detected
            unlock <= enable_validate & match & trigger_rising_edge;
        end
    end
endmodule