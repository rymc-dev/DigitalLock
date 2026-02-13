// =========================
// ModeController sub module - FIXED VERSION
// FSM for controller super states LOCKED and
// unlocked and sub state for unlocked unlocked programming
// =========================
module ModeController(
    input       unlock,
    input       swx_n,      // active-low reset
    input       swm,
    input       keya,
    input       clk,
    output reg  rledx,
    output reg  gledx,
    output reg [1:0] mode
);
    // ----------------------
    // 1. State encoding
    // ----------------------
    localparam LOCKED               = 2'b00,
               UNLOCKED             = 2'b01,
               UNLOCKED_PROGRAMMING = 2'b10;
    reg [1:0] state, next_state;
    
    // ----------------------
    // Edge detection for KEYA and SWM
    // ----------------------
    reg keya_d, swm_d;
    wire keya_posedge, swm_posedge, swm_negedge;
    
    initial begin 
        state  = LOCKED;    // ✓ Internal register
        keya_d = 1'b0;      // ✓ Internal register
        swm_d  = 1'b0;      // ✓ Internal register
        rledx  = 1'b1;      // ✓ Output register (can initialize)
        gledx  = 1'b0;      // ✓ Output register (can initialize)
    end
	 
    always @(posedge clk or negedge swx_n) begin
        if (!swx_n) begin
            keya_d <= 1'b0;
            swm_d  <= 1'b0;
        end
        else begin
            keya_d <= keya;
            swm_d  <= swm;
        end
    end
    
    assign keya_posedge = keya & ~keya_d;      // Rising edge of KEYA
    assign swm_posedge  = swm & ~swm_d;        // Rising edge of SWM
    assign swm_negedge  = ~swm & swm_d;        // Falling edge of SWM
    
    // ----------------------
    // 2. State register
    // ----------------------
    always @(posedge clk or negedge swx_n) begin
        if (!swx_n)
            state <= LOCKED;
        else
            state <= next_state;
    end
    
    // ----------------------
    // 3. Next-state logic - FIXED with edge detection
    // ----------------------
    always @(*) begin
        next_state = state;
        case (state)
            // ------------------------------------
            // LOCKED (00)
            // ------------------------------------
            LOCKED: begin
                // unlock = 1 → go to UNLOCKED
                if (unlock)
                    next_state = UNLOCKED;
            end
            
            // ------------------------------------
            // UNLOCKED (01)
            // ------------------------------------
            UNLOCKED: begin
                // KEYA pressed → return to LOCKED
                if (keya_posedge)
                    next_state = LOCKED;
                // SWM toggled high → enter programming mode
                else if (swm_posedge)
                    next_state = UNLOCKED_PROGRAMMING;
            end
            
            // ------------------------------------
            // UNLOCKED_PROGRAMMING (10)
            // ------------------------------------
            UNLOCKED_PROGRAMMING: begin
                // KEYA pressed → return to LOCKED
                if (keya_posedge)
                    next_state = LOCKED;
                // SWM toggled low → exit programming to UNLOCKED
                else if (swm_negedge)
                    next_state = UNLOCKED;
            end
        endcase
    end
    
    // ----------------------
    // 4. Moore Output Logic
    // ----------------------
    always @(*) begin
        mode = state;
        case (state)
            LOCKED: begin
                gledx = 0;
                rledx = 1;
            end
            UNLOCKED: begin
                gledx = 1;
                rledx = 0;
            end
            UNLOCKED_PROGRAMMING: begin
                gledx = 1;
                rledx = 1;  // Both LEDs on indicates programming mode
            end
            default: begin
                gledx = 0;
                rledx = 0;
            end
        endcase
    end
endmodule