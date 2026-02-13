// =========================
// CurrentCodeRegistry Module
// =========================
module CurrentCodeRegistry(
    input wire [15:0] code,          // New password to store (from CodeEntry)
    input wire shift,                // Store trigger (KEYA in programming mode)
    input wire rst_n,                // Active-low reset
    input wire clk,                  // System clock
    output reg [15:0] stored_code    // Current stored password
);
    /* 
        Stores the system password with edge-detected write control.
        
        Default Password: 0x2019 (BCD representation: 2-0-1-9)
        
        Operation:
        - On reset: Restore default password
        - On shift rising edge (in programming mode): Store new password
        - Otherwise: Maintain current password
        
        Edge detection prevents multiple writes per button press.
    */
    
    // ---- Default Password Definition ----
    localparam DEFAULT_PASSWORD = 16'h2019;  // Student ID: 2019
    
    // ---- Edge Detection Registers ----
    reg shift_delayed;               // Previous state of shift signal
    wire shift_rising_edge;          // Rising edge detection signal
    
    // Initialize stored password to default (for simulation)
    initial begin 
        stored_code = DEFAULT_PASSWORD;
    end
    
    // Detect rising edge of shift signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_delayed <= 1'b0;
        else
            shift_delayed <= shift;  // Store previous state
    end
    
    // Rising edge occurs when current is high and previous was low
    assign shift_rising_edge = shift & ~shift_delayed;
    
    // ---- Password Storage Logic ----
    // Store password on reset or rising edge of shift
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: restore default password
            stored_code <= DEFAULT_PASSWORD;
        end
        else if (shift_rising_edge) begin
            // Programming: store new password on rising edge only
            stored_code <= code;
        end
        // Otherwise: maintain current password
    end
    
endmodule
