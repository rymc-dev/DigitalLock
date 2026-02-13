// =========================
// ModeDecoder Module
// =========================
module ModeDecoder(
    input wire [1:0] mode,           // Current system mode from ModeController
    output reg enable_validate,      // Enable password validation
    output reg enable_program        // Enable password programming
);
    /* 
        Decodes the current system mode to determine which operations
        are permitted. Controls whether the system can validate passwords
        (for unlocking) or program new passwords.
        
        Mode Encoding:
        - 2'b00 (LOCKED):               Can validate to unlock
        - 2'b01 (UNLOCKED):             Can validate to re-lock
        - 2'b10 (UNLOCKED_PROGRAMMING): Can program new password
    */ 
    
    // ---- State Definitions ----
    localparam LOCKED               = 2'b00;
    localparam UNLOCKED             = 2'b01;
    localparam UNLOCKED_PROGRAMMING = 2'b10;
    
    // ---- Combinational Logic ----
    // Decode mode to generate enable signals
    always @(*) begin
        // Default: disable all operations
        enable_validate = 1'b0;
        enable_program  = 1'b0;
        
        case(mode)
            LOCKED: begin
                // In LOCKED state, allow validation to attempt unlock
                enable_validate = 1'b1;
                enable_program  = 1'b0;
            end
            
            UNLOCKED: begin
                // In UNLOCKED state, allow validation to re-lock
                enable_validate = 1'b1;
                enable_program  = 1'b0;
            end
            
            UNLOCKED_PROGRAMMING: begin
                // In PROGRAMMING state, allow new password storage
                enable_validate = 1'b0;
                enable_program  = 1'b1;
            end
            
            default: begin
                // Safety: disable all operations for undefined states
                enable_validate = 1'b0;
                enable_program  = 1'b0;
            end
        endcase
    end
    
endmodule