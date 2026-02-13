// =========================
// DirectionLogic Module
// =========================
module DirectionLogic(
    input up,            // Up button (KEYB)
    input down,          // Down button (KEYC)
    output reg dir,      // Direction: 1=up, 0=down
    output reg valid     // Valid: 1=single button pressed, 0=none or both
);
    /* 
        Combinational logic to decode button inputs into direction and validity.
        
        Truth Table:
        up | down | dir | valid | Action
        ---|------|-----|-------|------------------
        0  |  0   |  0  |   0   | No buttons: invalid
        0  |  1   |  0  |   1   | Down pressed: count down
        1  |  0   |  1  |   1   | Up pressed: count up
        1  |  1   |  0  |   0   | Both pressed: invalid (conflict)
        
        Output feeds into SinglePulse for edge-detected counting.
    */
    
    // ---- Direction Constants ----
    localparam DIR_UP = 1'b1;      // Count up direction
    localparam DIR_DOWN = 1'b0;    // Count down direction
    
    // ---- Validity Constants ----
    localparam IS_VALID = 1'b1;    // Valid button state
    localparam NOT_VALID = 1'b0;   // Invalid button state
    
    // ---- Combinational Decode Logic ----
    always @(*) begin
        casex({up, down})
            2'b00: begin
                // No buttons pressed
                dir = 1'b0;
                valid = NOT_VALID;
            end
            2'b01: begin
                // Down button only
                dir = DIR_DOWN;
                valid = IS_VALID;
            end
            2'b10: begin
                // Up button only
                dir = DIR_UP;
                valid = IS_VALID;
            end
            2'b11: begin
                // Both buttons pressed (conflict)
                dir = 1'b0;
                valid = NOT_VALID;
            end
            default: begin
                // Safety case
                dir = 1'b0;
                valid = NOT_VALID;
            end
        endcase
    end
endmodule
