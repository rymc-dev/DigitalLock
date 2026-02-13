
// =============================================================================
// SinglePulse Testbench - ANNOTATED FOR EDGE DETECTION VERIFICATION
// =============================================================================
/**
 * Edge Detector has 5 testable behaviors:
 * Path 1: No trigger → no pulse
 * Path 2: Rising edge → single pulse (one cycle)
 * Path 3: Held high → no additional pulses
 * Path 4: Multiple edges → multiple pulses
 * Path 5: Reset → pulse cleared
 */
`timescale 1ns/1ps
module SinglePulse_tb;
    // ======================
    // Testbench Signals
    // ======================
    reg clk;
    reg rst_n;
    reg trigger;
    wire pulse;
    
    // ======================
    // DUT
    // ======================
    SinglePulse DUT (
        .clk(clk),
        .rst_n(rst_n),
        .trigger(trigger),
        .pulse(pulse)
    );
    
    // ======================
    // Clock Generator
    // ======================
    initial begin 
        clk = 0;
        forever #10 clk = ~clk;   // 20ns period
    end
    
    // ======================
    // Monitor
    // ======================
    always @(posedge clk) begin
        $display("%0t rst_n=%b trigger=%b pulse=%b",
                 $time, rst_n, trigger, pulse);
    end
    
    // ======================
    // Test Stimulus
    // ======================
    initial begin
        $display("========================================");
        $display("SinglePulse Edge Detection Verification");
        $display("========================================");
        
        // Initial Conditions
        rst_n   = 0;
        trigger = 0;
        
        // Hold reset
        repeat (3) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        
        // ===================================================================
        // PATH 1: No trigger → no pulse
        // ===================================================================
        $display("\n--- PATH 1: No Trigger (pulse=0) ---");
        repeat (3) @(posedge clk);
        
        if (pulse !== 0)
            $fatal("✗ PATH 1 FAIL: Pulse active without trigger");
        else
            $display("✓ PATH 1 PASS: No pulse when trigger=0");
        
        // ===================================================================
        // PATH 2: Single rising edge → 1 cycle pulse
        // ===================================================================
        $display("\n--- PATH 2: Rising Edge Detection ---");
        trigger = 1;  // Create rising edge (0→1)
        @(posedge clk);
        
        if (pulse !== 1)
            $fatal("✗ PATH 2 FAIL: Expected pulse=1 on rising trigger");
        
        trigger = 0;  // Return to low
        @(posedge clk);
        
        if (pulse !== 0)
            $fatal("✗ PATH 2 FAIL: Pulse lasted more than one cycle");
        else
            $display("✓ PATH 2 PASS: Single-cycle pulse on rising edge");
        
        // ===================================================================
        // PATH 3: Hold trigger high → only one pulse
        // ===================================================================
        $display("\n--- PATH 3: Held High (no retrigger) ---");
        trigger = 1;
        @(posedge clk);   // First cycle: pulse should be 1
        
        if (pulse !== 1)
            $fatal("✗ PATH 3 FAIL: No pulse on initial rising edge");
        
        @(posedge clk);   // Second cycle: pulse should be 0
        @(posedge clk);   // Third cycle: still 0
        
        if (pulse !== 0)
            $fatal("✗ PATH 3 FAIL: Pulse retriggered while trigger held high");
        else
            $display("✓ PATH 3 PASS: No retrigger when held high");
        
        trigger = 0;
        @(posedge clk);
        
        // ===================================================================
        // PATH 4: Multiple trigger presses → multiple pulses
        // ===================================================================
        $display("\n--- PATH 4: Multiple Edges (multiple pulses) ---");
        repeat (3) begin
            trigger = 1;
            @(posedge clk);
            
            if (pulse !== 1)
                $fatal("✗ PATH 4 FAIL: Missing pulse on trigger press");
            
            trigger = 0;
            @(posedge clk);
            
            if (pulse !== 0)
                $fatal("✗ PATH 4 FAIL: Pulse not cleared");
        end
        $display("✓ PATH 4 PASS: Multiple edges produce multiple pulses");
        
        // ===================================================================
        // PATH 5: Reset during operation
        // ===================================================================
        $display("\n--- PATH 5: Reset Clears Pulse ---");
        trigger = 1;
        @(posedge clk);
        
        rst_n = 0;   // Force reset while pulse active
        @(posedge clk);
        
        if (pulse !== 0)
            $fatal("✗ PATH 5 FAIL: Pulse not cleared by reset");
        else
            $display("✓ PATH 5 PASS: Reset clears pulse");
        
        rst_n = 1;
        trigger = 0;
        @(posedge clk);
        
        // ===================================================================
        // Summary
        // ===================================================================
        $display("\n========================================");
        $display("SinglePulse Path Coverage: 5/5");
        $display("All tests passed.");
        $display("========================================\n");
        
        #50;
        $finish;
    end
endmodule
