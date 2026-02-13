// =========================
// ModeController sub module - FIXED VERSION
// FSM for controller super states LOCKED and
// unlocked and sub state for unlocked unlocked programming
// =========================
module ModeController(
    input       unlock,      // Unlock pulse from CodeControl when password validated
    input       swx_n,       // Active-low system reset
    input       swm,         // Mode switch for programming mode toggle
    input       keya,        // KEYA button (lock/restart)
    input       clk,         // System clock
    output reg  rledx,       // Red LED output (locked indicator)
    output reg  gledx,       // Green LED output (unlocked indicator)
    output reg [1:0] mode    // Current mode output to other modules
);
    /*
        Main system controller FSM managing lock states and mode transitions.
        
        States:
        - LOCKED (00):               System locked, red LED on
        - UNLOCKED (01):             System unlocked, green LED on
        - UNLOCKED_PROGRAMMING (10): Programming mode, both LEDs on
        
        Transitions:
        - Unlock pulse moves from LOCKED to UNLOCKED
        - KEYA button press returns to LOCKED from any state
        - SWM switch toggles between UNLOCKED and UNLOCKED_PROGRAMMING
        
        Uses edge detection to prevent rapid state changes from held buttons.
    */
    
    // ----------------------
    // 1. State encoding
    // ----------------------
    localparam LOCKED               = 2'b00,  // System locked state
               UNLOCKED             = 2'b01,  // System unlocked state
               UNLOCKED_PROGRAMMING = 2'b10;  // Password programming state
    
    reg [1:0] state, next_state;  // Current state and next state registers
    
    // ----------------------
    // 2. Edge detection for KEYA and SWM
    // ----------------------
    // Delayed versions of inputs for edge detection
    reg keya_d, swm_d;
    
    // Edge detection signals (pulse high for one clock cycle)
    wire keya_posedge;   // KEYA button press detected
    wire swm_posedge;    // SWM switch toggled high
    wire swm_negedge;    // SWM switch toggled low
    
    // Initialize registers for simulation and synthesis
    initial begin 
        state  = LOCKED;    // Start in locked state
        keya_d = 1'b0;      // Initialize edge detector
        swm_d  = 1'b0;      // Initialize edge detector
        rledx  = 1'b1;      // Red LED on (locked)
        gledx  = 1'b0;      // Green LED off
    end
    
    // Store previous button states for edge detection
    always @(posedge clk or negedge swx_n) begin
        if (!swx_n) begin
            keya_d <= 1'b0;  // Clear on reset
            swm_d  <= 1'b0;  // Clear on reset
        end
        else begin
            keya_d <= keya;  // Store current state for next cycle comparison
            swm_d  <= swm;   // Store current state for next cycle comparison
        end
    end
    
    // Generate edge detection pulses (high for one cycle on transition)
    assign keya_posedge = keya & ~keya_d;      // Rising edge: button pressed
    assign swm_posedge  = swm & ~swm_d;        // Rising edge: switch turned on
    assign swm_negedge  = ~swm & swm_d;        // Falling edge: switch turned off
    
    // ----------------------
    // 3. State register
    // ----------------------
    // Update current state on clock edge or asynchronous reset
    always @(posedge clk or negedge swx_n) begin
        if (!swx_n)
            state <= LOCKED;      // Asynchronous reset to locked state
        else
            state <= next_state;  // Synchronous state update
    end
    
    // ----------------------
    // 4. Next-state logic - FIXED with edge detection
    // ----------------------
    // Combinational logic to determine next state based on current state and inputs
    always @(*) begin
        next_state = state;  // Default: remain in current state
        
        case (state)
            // ------------------------------------
            // LOCKED (00)
            // ------------------------------------
            LOCKED: begin
                // Transition: unlock pulse → UNLOCKED
                // Unlock pulse generated when correct password entered
                if (unlock)
                    next_state = UNLOCKED;
            end
            
            // ------------------------------------
            // UNLOCKED (01)
            // ------------------------------------
            UNLOCKED: begin
                // Priority 1: KEYA button press → return to LOCKED
                if (keya_posedge)
                    next_state = LOCKED;
                // Priority 2: SWM toggled high → enter PROGRAMMING mode
                else if (swm_posedge)
                    next_state = UNLOCKED_PROGRAMMING;
            end
            
            // ------------------------------------
            // UNLOCKED_PROGRAMMING (10)
            // ------------------------------------
            UNLOCKED_PROGRAMMING: begin
                // Priority 1: KEYA button press → return to LOCKED
                if (keya_posedge)
                    next_state = LOCKED;
                // Priority 2: SWM toggled low → exit to UNLOCKED
                else if (swm_negedge)
                    next_state = UNLOCKED;
            end
        endcase
    end
    
    // ----------------------
    // 5. Moore Output Logic
    // ----------------------
    // Outputs depend only on current state (Moore machine)
    always @(*) begin
        mode = state;  // Mode output directly reflects current state
        
        case (state)
            LOCKED: begin
                gledx = 0;  // Green LED off
                rledx = 1;  // Red LED on (indicates locked)
            end
            
            UNLOCKED: begin
                gledx = 1;  // Green LED on (indicates unlocked)
                rledx = 0;  // Red LED off
            end
            
            UNLOCKED_PROGRAMMING: begin
                gledx = 1;  // Green LED on (still unlocked)
                rledx = 1;  // Red LED also on (indicates programming mode)
            end
            
            default: begin
                gledx = 0;  // Both LEDs off (error/undefined state)
                rledx = 0;
            end
        endcase
    end
    
endmodule