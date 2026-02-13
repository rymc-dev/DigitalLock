// =========================
// CodeEqualityChecker Module
// =========================
module CodeEqualityChecker(
    input wire [15:0] a,             // First 16-bit code (entered code)
    input wire [15:0] b,             // Second 16-bit code (stored password)
    output wire match                // High if codes match
);
    /* 
        Compares two 16-bit codes for equality.
        
        Used to verify if the entered code matches the stored password.
        Pure combinational logic - no clock or state.
    */
    
    // ---- Comparison Logic ----
    // Match is high when all 16 bits are identical
    assign match = (a == b) ? 1'b1 : 1'b0;
    
endmodule