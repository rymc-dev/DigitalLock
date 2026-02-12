`timescale 1ns / 1ps

/**
 * Testbench for digital_lock_system
 * Tests all major functionality including:
 * - System reset
 * - Code entry with up/down buttons
 * - Correct code unlock
 * - Incorrect code handling
 * - Lock functionality (KEYA)
 * - Programming mode
 */
module DigitalLockSystem_tb;

    // Testbench signals
    reg  swx_n;
    reg  swm;
    reg  keya;
    reg  keyb;
    reg  keyc;
    reg  keyd;
    reg  clk;
    wire rledx;
    wire gledx;
    wire [15:0] hexx_y;

    // Previous state tracking for monitoring (replaces $past)
    reg prev_rledx;
    reg prev_gledx;

    // Clock generation - 50MHz (20ns period)
    always begin
        clk = 0;
        #10;
        clk = 1;
        #10;
    end

    // Instantiate the Unit Under Test (UUT)
    digital_lock_system uut (
        .swx_n(swx_n),
        .swm(swm),
        .keya(keya),
        .keyb(keyb),
        .keyc(keyc),
        .keyd(keyd),
        .clk(clk),
        .rledx(rledx),
        .gledx(gledx),
        .hexx_y(hexx_y)
    );

    // Task to press a button
    // Keys A-D trigger on posedge (0→1 transition)
    task press_button;
        input [3:0] button_select; // 0=KEYA, 1=KEYB, 2=KEYC, 3=KEYD
        input integer duration_cycles;
        begin
            case(button_select)
                4'd0: begin
                    keya = 1;  // Create posedge (0→1)
                    repeat(duration_cycles) @(posedge clk);
                    keya = 0;  // Return to idle
                end
                4'd1: begin
                    keyb = 1;
                    repeat(duration_cycles) @(posedge clk);
                    keyb = 0;
                end
                4'd2: begin
                    keyc = 1;
                    repeat(duration_cycles) @(posedge clk);
                    keyc = 0;
                end
                4'd3: begin
                    keyd = 1;
                    repeat(duration_cycles) @(posedge clk);
                    keyd = 0;
                end
            endcase
            repeat(5) @(posedge clk); // Debounce delay
        end
    endtask

    // Task to enter a digit by pressing up or down buttons
    task enter_digit;
        input [3:0] target_digit;
        input [3:0] current_digit;
        integer i;
        integer diff;
        begin
            $display("Time=%0t: Entering digit %0d (current=%0d)", $time, target_digit, current_digit);
            
            // Calculate difference
            if (target_digit >= current_digit)
                diff = target_digit - current_digit;
            else
                diff = (10 - current_digit) + target_digit;
            
            // Press up button to reach target
            for (i = 0; i < diff; i = i + 1) begin
                press_button(4'd1, 3); // KEYB (up)
            end
            
            // Press entry button
            press_button(4'd3, 3); // KEYD (entry)
        end
    endtask

    // Task to display current system state
    task display_state;
        begin
            $display("Time=%0t: RLED=%b GLED=%b HEX=%h", 
                     $time, rledx, gledx, hexx_y);
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize waveform dump
        $dumpfile("DigitalLockSystem_tb.vcd");
        $dumpvars(0, DigitalLockSystem_tb);
        
        // Initialize all inputs
        swx_n = 1;  // Reset is active low (negedge triggered)
        swm = 0;    // Normal mode (not programming)
        keya = 0;   // Buttons idle at 0 (posedge triggered)
        keyb = 0;
        keyc = 0;
        keyd = 0;
        
        // Initialize previous state tracking
        prev_rledx = 0;
        prev_gledx = 0;
        
        $display("========================================");
        $display("Digital Lock System Testbench Starting");
        $display("========================================");
        
        // Test 1: System Reset
        $display("\n--- Test 1: System Reset ---");
        swx_n = 0;
        repeat(10) @(posedge clk);
        swx_n = 1;
        repeat(10) @(posedge clk);
        display_state();
        
        // Test 2: Lock the system (press KEYA)
        $display("\n--- Test 2: Lock System (KEYA) ---");
        press_button(4'd0, 3); // KEYA
        repeat(10) @(posedge clk);
        display_state();
        if (rledx)
            $display("PASS: Red LED is ON (system locked)");
        else
            $display("FAIL: Red LED should be ON");
        
        // Test 3: Test digit increment (KEYB - up button)
        $display("\n--- Test 3: Test Up Button (KEYB) ---");
        repeat(3) begin
            press_button(4'd1, 3); // KEYB
            repeat(5) @(posedge clk);
            display_state();
        end
        
        // Test 4: Test digit decrement (KEYC - down button)
        $display("\n--- Test 4: Test Down Button (KEYC) ---");
        repeat(2) begin
            press_button(4'd2, 3); // KEYC
            repeat(5) @(posedge clk);
            display_state();
        end
        
        // Test 5: Enter incorrect code sequence
        $display("\n--- Test 5: Enter Incorrect Code ---");
        press_button(4'd0, 3); // KEYA (restart/lock)
        repeat(10) @(posedge clk);
        
        // Example: Try to enter 1234 (adjust based on your actual code)
        // Assuming code starts at 0
        enter_digit(4'd1, 4'd0);
        repeat(10) @(posedge clk);
        display_state();
        
        enter_digit(4'd2, 4'd0);
        repeat(10) @(posedge clk);
        display_state();
        
        enter_digit(4'd3, 4'd0);
        repeat(10) @(posedge clk);
        display_state();
        
        enter_digit(4'd4, 4'd0);
        repeat(20) @(posedge clk);
        display_state();
        
        if (!gledx)
            $display("PASS: Green LED is OFF (incorrect code)");
        else
            $display("INFO: Green LED is ON (code may have been correct)");
        
        // Test 6: Enter correct code sequence
        // NOTE: Replace these digits with the last X digits of your student ID
        $display("\n--- Test 6: Enter Correct Code (Student ID) ---");
        press_button(4'd0, 3); // KEYA (restart/lock)
        repeat(10) @(posedge clk);
        
        // Example: Enter your actual student ID digits here
        // For demonstration, entering 5678
        $display("INFO: Adjust these digits to match your student ID!");
        
        enter_digit(4'd5, 4'd0);
        repeat(10) @(posedge clk);
        display_state();
        
        enter_digit(4'd6, 4'd0);
        repeat(10) @(posedge clk);
        display_state();
        
        enter_digit(4'd7, 4'd0);
        repeat(10) @(posedge clk);
        display_state();
        
        enter_digit(4'd8, 4'd0);
        repeat(20) @(posedge clk);
        display_state();
        
        if (gledx)
            $display("PASS: Green LED is ON (system unlocked)");
        else
            $display("FAIL: Green LED should be ON for correct code");
        
        // Test 7: Programming Mode (if unlocked)
        $display("\n--- Test 7: Programming Mode ---");
        if (gledx) begin
            $display("System is unlocked, testing programming mode...");
            swm = 1; // Switch to programming mode
            repeat(10) @(posedge clk);
            display_state();
            
            // Enter new code sequence
            $display("Entering new code: 9876");
            enter_digit(4'd9, 4'd0);
            repeat(10) @(posedge clk);
            
            enter_digit(4'd8, 4'd0);
            repeat(10) @(posedge clk);
            
            enter_digit(4'd7, 4'd0);
            repeat(10) @(posedge clk);
            
            enter_digit(4'd6, 4'd0);
            repeat(20) @(posedge clk);
            display_state();
            
            swm = 0; // Back to normal mode
            repeat(10) @(posedge clk);
        end else begin
            $display("Skipping programming mode test (system not unlocked)");
        end
        
        // Test 8: Lock and test new code (if programming was done)
        $display("\n--- Test 8: Test New Code After Programming ---");
        press_button(4'd0, 3); // KEYA (lock)
        repeat(10) @(posedge clk);
        display_state();
        
        // Try the new code
        enter_digit(4'd9, 4'd0);
        repeat(10) @(posedge clk);
        
        enter_digit(4'd8, 4'd0);
        repeat(10) @(posedge clk);
        
        enter_digit(4'd7, 4'd0);
        repeat(10) @(posedge clk);
        
        enter_digit(4'd6, 4'd0);
        repeat(20) @(posedge clk);
        display_state();
        
        if (gledx)
            $display("PASS: New programmed code works!");
        else
            $display("INFO: Check if programming mode implementation affects this");
        
        // Test 9: System Reset (should restore default code)
        $display("\n--- Test 9: System Reset to Default ---");
        swx_n = 0;
        repeat(10) @(posedge clk);
        swx_n = 1;
        repeat(10) @(posedge clk);
        display_state();
        $display("System reset to default code");
        
        // Test 10: Edge case - Rapid button presses
        $display("\n--- Test 10: Rapid Button Presses ---");
        press_button(4'd0, 3); // KEYA (lock)
        repeat(5) @(posedge clk);
        
        repeat(5) begin
            press_button(4'd1, 1); // Quick presses
        end
        repeat(10) @(posedge clk);
        display_state();
        
        // Final summary
        $display("\n========================================");
        $display("Testbench Complete");
        $display("========================================");
        $display("Please verify:");
        $display("1. Red LED turns ON when locked");
        $display("2. Green LED turns ON with correct code");
        $display("3. Display shows entered digits");
        $display("4. Programming mode allows code change");
        $display("5. Reset restores default code");
        $display("========================================\n");
        
        repeat(50) @(posedge clk);
        $finish;
    end

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    // Monitor for significant changes (using reg-based tracking instead of $past)
    always @(posedge clk) begin
        // Update previous values
        prev_rledx <= rledx;
        prev_gledx <= gledx;
        
        // Check for changes
        if (rledx !== prev_rledx || gledx !== prev_gledx) begin
            $display("Time=%0t: LED change - RLED=%b GLED=%b", $time, rledx, gledx);
        end
    end

endmodule