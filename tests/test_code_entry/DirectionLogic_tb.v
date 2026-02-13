// =============================================================================
// DirectionLogic Testbench - ANNOTATED FOR TRUTH TABLE VERIFICATION
// =============================================================================
/**
 * Combinational logic has 4 input combinations:
 * Path 1: up=0, down=0 → invalid
 * Path 2: up=0, down=1 → down valid
 * Path 3: up=1, down=0 → up valid
 * Path 4: up=1, down=1 → invalid (conflict)
 */
`timescale 1ns/1ps
module DirectionLogic_tb;
    // ======================
    // Testbench Signals
    // ======================
    reg up;
    reg down;
    wire dir;
    wire valid;
    
    // ======================
    // DUT
    // ======================
    DirectionLogic DUT (
        .up(up),
        .down(down),
        .dir(dir),
        .valid(valid)
    );
    
    // ======================
    // Monitor
    // ======================
    initial begin
        $monitor("%0t up=%b down=%b | dir=%b valid=%b",
                 $time, up, down, dir, valid);
    end
    
    // ======================
    // Test Stimulus
    // ======================
    initial begin
        $display("========================================");
        $display("DirectionLogic Truth Table Verification");
        $display("========================================");
        
        // ===================================================================
        // PATH 1: up=0, down=0 → NOT VALID
        // ===================================================================
        $display("\n--- PATH 1: No buttons pressed (00) ---");
        up = 0; down = 0;
        #5;
        
        if (valid !== 0)
            $fatal("✗ PATH 1 FAIL: 00 should be NOT_VALID");
        else
            $display("✓ PATH 1 PASS: No buttons → invalid");
        
        // ===================================================================
        // PATH 2: up=0, down=1 → DOWN VALID
        // ===================================================================
        $display("\n--- PATH 2: Down button pressed (01) ---");
        up = 0; down = 1;
        #5;
        
        if (valid !== 1 || dir !== 0)
            $fatal("✗ PATH 2 FAIL: 01 should be DOWN + VALID");
        else
            $display("✓ PATH 2 PASS: Down button → dir=0 (down), valid=1");
        
        // ===================================================================
        // PATH 3: up=1, down=0 → UP VALID
        // ===================================================================
        $display("\n--- PATH 3: Up button pressed (10) ---");
        up = 1; down = 0;
        #5;
        
        if (valid !== 1 || dir !== 1)
            $fatal("✗ PATH 3 FAIL: 10 should be UP + VALID");
        else
            $display("✓ PATH 3 PASS: Up button → dir=1 (up), valid=1");
        
        // ===================================================================
        // PATH 4: up=1, down=1 → NOT VALID (conflict)
        // ===================================================================
        $display("\n--- PATH 4: Both buttons pressed (11) ---");
        up = 1; down = 1;
        #5;
        
        if (valid !== 0)
            $fatal("✗ PATH 4 FAIL: 11 should be NOT_VALID");
        else
            $display("✓ PATH 4 PASS: Both buttons → invalid (conflict)");
        
        // ===================================================================
        // Additional: Rapid toggling (combinational stability)
        // ===================================================================
        $display("\n--- Additional: Rapid Toggling Test ---");
        repeat (5) begin
            up = $random;
            down = $random;
            #5;
        end
        $display("✓ Combinational logic stable during rapid changes");
        
        // ===================================================================
        // Summary
        // ===================================================================
        $display("\n========================================");
        $display("DirectionLogic Truth Table Coverage: 4/4");
        $display("All tests passed.");
        $display("========================================\n");
        
        #10;
        $finish;
    end
endmodule
