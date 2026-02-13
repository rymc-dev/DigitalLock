// =========================
// SinglePulse Module
// =========================
module SinglePulse(
    input wire clk,        // System clock
    input wire rst_n,      // Active-low reset
    input wire trigger,    // Input signal to detect
    output reg pulse       // Single-cycle pulse on rising edge
);
    /*
        Edge detector that converts a level signal into a single-clock pulse.
        
        Operation:
        - Detects rising edge of trigger signal (0→1 transition)
        - Outputs high for exactly one clock cycle
        - Prevents multiple counts from held buttons
        
        Used to convert continuous button press into single increment/decrement.
    */
    
    // ---- Edge Detection Register ----
    reg trigger_delayed;  // Previous state of trigger
    
    // Store previous state of trigger for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            trigger_delayed <= 1'b0;
        else
            trigger_delayed <= trigger;  // Delay by one clock cycle
    end 
    
    // ---- Pulse Generation ----
    // Generate single-cycle pulse on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pulse <= 1'b0;
        end
        else begin
            // Pulse high when trigger is high AND previous was low (rising edge)
            pulse <= trigger & ~trigger_delayed;
        end
    end
endmodule