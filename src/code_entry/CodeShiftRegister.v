
// =========================
// CodeShiftRegister Module
// =========================
module CodeShiftRegister(
    input  [3:0] digit,      // Current digit from counter (0-9)
    input        rst_n,      // Active-low reset
    input        shift,      // Shift trigger (KEYD button)
    input        clk,        // System clock
    output reg [15:0] code   // 16-bit code (4 digits, 4 bits each)
);
    /*
        Shift register for storing 4-digit code with live preview.
        
        Operation:
        - Stores 4 decimal digits as 4-bit nibbles (big-endian)
        - On shift button (KEYD): locks current digit and advances position
        - Between shifts: displays live preview of current digit selection
        - Wraps to position 0 after 4th digit entered
        
        Code Format: [Digit0][Digit1][Digit2][Digit3]
                     bits 15-12  11-8   7-4    3-0
    */
    
    // ---- Position Tracking ----
    reg [1:0] segment;           // Current digit position (0-3)
    
    // ---- Edge Detection for Shift ----
    reg shift_delayed;           // Previous state of shift signal
    wire shift_posedge;          // Rising edge of shift
    
    // ---- Initialization ----
    initial begin 
        code = 16'b0;            // Clear code display
        segment = 2'd0;          // Start at first digit
        shift_delayed = 1'b0;    // Initialize edge detector
    end
    
    // Detect rising edge of shift button
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_delayed <= 1'b0;
        else
            shift_delayed <= shift;  // Store previous state
    end
    
    // Rising edge when current is high and previous was low
    assign shift_posedge = shift & ~shift_delayed;
    
    // ---- Shift Register Logic ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: clear code and return to first digit
            code    <= 16'b0;
            segment <= 2'd0;
        end
        else if (shift_posedge) begin
            // Shift button pressed: lock in current digit
            code[15 - segment*4 -: 4] <= digit;  // Store digit at current position
            
            // Advance to next position (wrap after 4 digits)
            if (segment == 2'd3)
                segment <= 2'd0;     // Wrap to start
            else
                segment <= segment + 1;  // Next position
        end
        else begin 
            // Live preview: show current digit selection before shift
            code[15 - segment*4 -: 4] <= digit;
        end
    end
endmodule
