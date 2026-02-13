// =========================
// UpDownCounterWrap Module
// =========================
module UpDownCounterWrap(
    input wire clk,          // System clock
    input wire rst_n,        // Active-low reset
    input wire ud,           // Direction: 1=up, 0=down
    input wire trigger,      // Increment/decrement trigger pulse
    input wire clear,        // Synchronous clear to reset counter
    output reg [3:0] count   // Current count value (0-9)
);
    /*
        Decimal counter with wrap-around behavior (0-9 range).
        
        Operation:
        - Counts up when ud=1 (wraps 9→0)
        - Counts down when ud=0 (wraps 0→9)
        - Only counts on trigger pulse (from SinglePulse)
        - Clear signal resets to 0 (used on digit shift or mode change)
        
        Used for digit selection in code entry system.
    */
    
    // ---- Initialization ----
    // Initialize counter to 0 for simulation
    initial begin
        count = 4'b0000;
    end
    
    // ---- Counter Logic ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: return to 0
            count <= 4'b0000;
        end
        else if (clear) begin 
            // Synchronous clear: reset counter (on shift or mode change)
            count <= 4'b0000;
        end 
        else if (trigger) begin
            // Count only when trigger pulse received
            if (ud) begin
                // Count up with wrap-around
                if (count == 4'b1001)  // At 9
                    count <= 4'b0000;   // Wrap to 0
                else
                    count <= count + 1; // Increment
            end
            else begin
                // Count down with wrap-around
                if (count == 4'b0000)  // At 0
                    count <= 4'b1001;   // Wrap to 9
                else
                    count <= count - 1'b1; // Decrement
            end
        end
        // Otherwise: hold current value
    end
endmodule
