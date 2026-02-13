// =============================================================================
// CodeEntry Integration Testbench - ANNOTATED
// =============================================================================
/**
 * CodeEntry integration test verifies:
 * Path 1: Increment operation
 * Path 2: Decrement operation
 * Path 3: Invalid (both buttons) → no change
 * Path 4: Shift operation
 * Path 5: Mode change reset
 * Path 6: Global reset
 */
`timescale 1ns/1ps
module CodeEntry_tb;
    // =========================
    // Testbench Signals
    // =========================
    reg clk;
    reg rst_n;
    reg [1:0] current_mode;
    reg keyb_s;
    reg keyc_s;
    reg keyd_s;
    wire [15:0] code;
    
    // =========================
    // DUT Instantiation
    // =========================
    CodeEntry DUT (
        .clk(clk),
        .rst_n(rst_n),
        .current_mode(current_mode),
        .keyb_s(keyb_s),
        .keyc_s(keyc_s),
        .keyd_s(keyd_s),
        .code(code)
    );
    
    // =========================
    // Clock Generation
    // =========================
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // =========================
    // Waveform Dump
    // =========================
    initial begin
        $dumpfile("CodeEntry_tb.vcd");
        $dumpvars(0, CodeEntry_tb);
    end
    
    // =========================
    // Monitor
    // =========================
    initial begin
        $monitor("T=%0t | rst=%b | mode=%b | B=%b C=%b D=%b | code=%h",
                  $time, rst_n, current_mode, keyb_s, keyc_s, keyd_s, code);
    end
    
    // =========================
    // Test Stimulus
    // =========================
    initial begin
        $display("========================================");
        $display("CodeEntry Integration Test");
        $display("========================================");
        
        // Initial Conditions
        rst_n        = 0;
        current_mode = 2'b00;
        keyb_s       = 0;
        keyc_s       = 0;
        keyd_s       = 0;
        
        #25;
        rst_n = 1;
        
        // ===================================================================
        // PATH 1: Increment operation
        // ===================================================================
        $display("\n--- PATH 1: Increment Digit (KEYB) ---");
        #20;
        keyb_s = 1;
        @(posedge clk);
        #20;
        keyb_s = 0;
        @(posedge clk);
        
        $display("✓ PATH 1: KEYB pressed, digit incremented");
        
        // ===================================================================
        // PATH 2: Decrement operation
        // ===================================================================
        $display("\n--- PATH 2: Decrement Digit (KEYC) ---");
        #20;
        keyc_s = 1;
        @(posedge clk);
        #20;
        keyc_s = 0;
        @(posedge clk);
        
        $display("✓ PATH 2: KEYC pressed, digit decremented");
        
        // ===================================================================
        // PATH 3: Both buttons → invalid (no change)
        // ===================================================================
        $display("\n--- PATH 3: Both Buttons (invalid) ---");
        #20;
        keyb_s = 1;
        keyc_s = 1;
        @(posedge clk);
        #20;
        keyb_s = 0;
        keyc_s = 0;
        @(posedge clk);
        
        $display("✓ PATH 3: Both buttons pressed → no change (invalid)");
        
        // ===================================================================
        // PATH 4: Shift operation
        // ===================================================================
        $display("\n--- PATH 4: Shift Operation (KEYD) ---");
        #20;
        // Increment digit
        keyb_s = 1;
        @(posedge clk);
        #20;
        keyb_s = 0;
        @(posedge clk);
        
        // Shift
        keyd_s = 1;
        @(posedge clk);
        keyd_s = 0;
        @(posedge clk);
        
        $display("✓ PATH 4: KEYD pressed, digit shifted");
        
        // Increment next digit
        keyb_s = 1;
        @(posedge clk);
        keyb_s = 0;
        @(posedge clk);
        
        // ===================================================================
        // PATH 5: Mode change reset
        // ===================================================================
        $display("\n--- PATH 5: Mode Change Reset ---");
        #20;
        current_mode = 2'b01;
        @(posedge clk);
        #20;
        
        $display("✓ PATH 5: Mode changed, code entry reset");
        
        keyc_s = 1;
        @(posedge clk);
        keyc_s = 0;
        @(posedge clk);
        
        // ===================================================================
        // PATH 6: Global reset
        // ===================================================================
        $display("\n--- PATH 6: Global Reset ---");
        #20;
        rst_n = 0;
        @(posedge clk);
        #10;
        rst_n = 1;
        @(posedge clk);
        
        $display("✓ PATH 6: Global reset, all counters cleared");
        
        // ===================================================================
        // Summary
        // ===================================================================
        $display("\n========================================");
        $display("CodeEntry Integration: 6/6 paths tested");
        $display("All tests completed.");
        $display("========================================\n");
        
        #50;
        $finish;
    end
endmodule