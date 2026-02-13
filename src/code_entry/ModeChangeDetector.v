// =========================
// ModeChangeDetector Module
// =========================
module ModeChangeDetector(
    input clk,                     // System clock
    input rst_n,                   // Active-low reset
    input [1:0] current_mode,      // Current system mode
    output reg is_mode_change      // High for one cycle on mode change
);
    /*
        Detects changes in system mode and generates a single-cycle pulse.
        
        Operation:
        - Compares current mode with previous mode
        - Outputs pulse for one clock cycle when mode changes
        - Used to reset shift register and counter on mode transitions
        
        Modes: LOCKED (00), UNLOCKED (01), UNLOCKED_PROGRAMMING (10)
    */
    
    // ---- Previous Mode Storage ----
    reg [1:0] previous_mode;  // Stores mode from previous clock cycle
    
    // ---- Mode Change Detection Logic ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            // Reset: initialize to LOCKED mode
            previous_mode <= 2'b00;
            is_mode_change <= 1'b0;
        end
        else if (current_mode != previous_mode) begin
            // Mode has changed: update previous and signal change
            previous_mode <= current_mode;
            is_mode_change <= 1'b1;  // Pulse high for one cycle
        end
        else begin
            // Mode unchanged: clear change signal
            is_mode_change <= 1'b0;
        end
    end
endmodule