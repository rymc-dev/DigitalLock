`timescale 1ns/1ps

// =============================================================================
// UpDownCounterWrap Testbench - ANNOTATED FOR ASM PATH COVERAGE
// =============================================================================
/**
 * Counter ASM has 7 testable paths:
 * Path 1: Reset → count=0 (asynchronous)
 * Path 2: No trigger → count unchanged
 * Path 3: Trigger + up + count<9 → count+1
 * Path 4: Trigger + up + count=9 → wrap to 0
 * Path 5: Trigger + down + count>0 → count-1
 * Path 6: Trigger + down + count=0 → wrap to 9
 * Path 7: Clear → count=0 (synchronous)
 */
module UpDownCounterWrap_tb;
    // ======================
    // Testbench Signals
    // ======================
    reg clk;
    reg rst_n;
    reg ud;
    reg trigger;
    reg clear;
    wire [3:0] count;
    
    // =========================
    // Instantiate DUT
    // =========================
    UpDownCounterWrap DUT(
        .clk(clk),
        .rst_n(rst_n),
        .ud(ud),
        .trigger(trigger),
        .clear(clear),
        .count(count)
    );
    
    // ===================
    // Clock Generator
    // ===================
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period
    end
    
    // Simple monitor
    always @(posedge clk) begin
        $display("%0t clk posedge : rst_n=%b clear=%b ud=%b trigger=%b count=%b (%0d)",
                 $time, rst_n, clear, ud, trigger, count, count);
    end
    
    // =================
    // Test stimulus
    // =================
    initial begin
        $display("========================================");
        $display("UpDownCounterWrap ASM Path Coverage");
        $display("========================================");
        
        // Initial input values
        rst_n   = 0;
        ud      = 0;
        trigger = 0;
        clear   = 0;
        
        // ===================================================================
        // PATH 1: Asynchronous Reset → count = 0
        // ===================================================================
        $display("\n--- PATH 1: Asynchronous Reset ---");
        repeat (3) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        
        if (count !== 4'd0) 
            $fatal("✗ PATH 1 FAIL: After reset expected count==0 but got %0d", count);
        else
            $display("✓ PATH 1 PASS: Counter reset to 0");
        
        // ===================================================================
        // PATH 2: No Trigger → count unchanged
        // ===================================================================
        $display("\n--- PATH 2: No Trigger (count unchanged) ---");
        ud = 1; trigger = 0;  // Set direction but no trigger
        @(posedge clk);
        ud = 0;
        @(posedge clk);
        
        if (count !== 4'd0) 
            $fatal("✗ PATH 2 FAIL: Count changed without trigger: expected 0 got %0d", count);
        else
            $display("✓ PATH 2 PASS: Count unchanged without trigger");
        
        // ===================================================================
        // PATH 3: Trigger + Up + count<9 → count+1
        // ===================================================================
        $display("\n--- PATH 3: Increment (count<9) ---");
        ud = 1;        // Request up
        trigger = 1;   // Assert trigger
        @(posedge clk);
        trigger = 0;
        @(posedge clk);
        
        if (count !== 4'd1) 
            $fatal("✗ PATH 3 FAIL: Increment failed: expected 1 got %0d", count);
        else
            $display("✓ PATH 3 PASS: Counter incremented 0→1");
        
        // ===================================================================
        // PATH 5: Trigger + Down + count>0 → count-1
        // ===================================================================
        $display("\n--- PATH 5: Decrement (count>0) ---");
        ud = 0; trigger = 1;  // Request down
        @(posedge clk);
        trigger = 0;
        @(posedge clk);
        
        if (count !== 4'd0) 
            $fatal("✗ PATH 5 FAIL: Decrement failed: expected 0 got %0d", count);
        else
            $display("✓ PATH 5 PASS: Counter decremented 1→0");
        
        // ===================================================================
        // PATH 6: Trigger + Down + count=0 → wrap to 9
        // ===================================================================
        $display("\n--- PATH 6: Decrement Wrap-around (0→9) ---");
        ud = 0; trigger = 1;
        @(posedge clk);
        trigger = 0;
        @(posedge clk);
        
        if (count !== 4'd9) 
            $fatal("✗ PATH 6 FAIL: Wrap-around (decrement) failed: expected 9 got %0d", count);
        else
            $display("✓ PATH 6 PASS: Counter wrapped 0→9");
        
        // ===================================================================
        // PATH 4: Trigger + Up + count=9 → wrap to 0
        // ===================================================================
        $display("\n--- PATH 4: Increment Wrap-around (9→0) ---");
        ud = 1; trigger = 1;
        @(posedge clk);
        trigger = 0;
        @(posedge clk);
        
        if (count !== 4'd0) 
            $fatal("✗ PATH 4 FAIL: Wrap-around (increment) failed: expected 0 got %0d", count);
        else
            $display("✓ PATH 4 PASS: Counter wrapped 9→0");
        
        // ===================================================================
        // PATH 7: Synchronous Clear → count = 0
        // ===================================================================
        $display("\n--- PATH 7: Synchronous Clear ---");
        // First increment to non-zero value
        ud = 1; trigger = 1;
        @(posedge clk);
        ud = 1; trigger = 1;
        @(posedge clk);
        ud = 1; trigger = 1;
        @(posedge clk);
        trigger = 0;
        @(posedge clk);
        
        $display("Counter value before clear: %0d", count);
        
        // Now assert clear
        clear = 1;
        @(posedge clk);
        clear = 0;
        
        if (count !== 4'd0) 
            $fatal("✗ PATH 7 FAIL: Clear failed: expected 0 got %0d", count);
        else
            $display("✓ PATH 7 PASS: Counter cleared to 0");
        
        // ===================================================================
        // PATH 1 (Alternative): Reset during operation
        // ===================================================================
        $display("\n--- PATH 1 (Alternative): Reset during counting ---");
        ud = 1; trigger = 1;
        @(posedge clk);
        @(posedge clk);
        
        rst_n = 0;  // Assert reset
        @(posedge clk);
        rst_n = 1;
        
        if (count !== 4'd0) 
            $fatal("✗ PATH 1 ALT FAIL: Reset during operation failed: expected 0 got %0d", count);
        else
            $display("✓ PATH 1 ALT PASS: Reset works during operation");
        
        // ===================================================================
        // Summary
        // ===================================================================
        $display("\n========================================");
        $display("UpDownCounterWrap Path Coverage: 7/7");
        $display("All tests passed.");
        $display("========================================\n");
        
        #100 $finish;
    end
endmodule
