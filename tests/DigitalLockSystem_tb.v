`timescale 1ns / 1ps

/**
 * Testbench for DigitalLockSystem - ACTIVE-LOW Button Configuration
 * Matches Altera DE2 Board Hardware
 * Buttons idle at 1 (HIGH), press creates NEGEDGE (1→0)
 * Top-level module inverts signals internally for easier logic
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

    // Previous state tracking for monitoring
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
    DigitalLockSystem uut (
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

    // Task to press a button - ACTIVE-LOW configuration (DE2 Board)
    // Buttons idle at 1, press creates NEGEDGE (1→0)
    task press_button;
        input [3:0] button_select; // 0=KEYA, 1=KEYB, 2=KEYC, 3=KEYD
        input integer duration_cycles;
        begin
            case(button_select)
                4'd0: begin
                    keya = 0;  // Press (creates NEGEDGE 1→0)
                    repeat(duration_cycles) @(posedge clk);
                    keya = 1;  // Release (return to idle HIGH)
                end
                4'd1: begin
                    keyb = 0;  // Press LOW
                    repeat(duration_cycles) @(posedge clk);
                    keyb = 1;  // Release HIGH
                end
                4'd2: begin
                    keyc = 0;  // Press LOW
                    repeat(duration_cycles) @(posedge clk);
                    keyc = 1;  // Release HIGH
                end
                4'd3: begin
                    keyd = 0;  // Press LOW
                    repeat(duration_cycles) @(posedge clk);
                    keyd = 1;  // Release HIGH
                end
            endcase
            repeat(10) @(posedge clk); // Debounce delay
        end
    endtask

    // Task to enter a digit by automatically reading current display and incrementing
    task enter_digit;
        input [3:0] target_digit;
        reg [3:0] current_display;
        integer i;
        integer diff;
        begin
            // Read current digit from hex display (rightmost nibble)
            current_display = hexx_y[3:0];
            
            $display("Time=%0t: Entering digit %0d (display currently shows=%0d)", 
                     $time, target_digit, current_display);
            
            // Calculate difference with wrapping (0-9)
            if (target_digit >= current_display)
                diff = target_digit - current_display;
            else
                diff = (10 - current_display) + target_digit;
            
            // Press up button to reach target
            for (i = 0; i < diff; i = i + 1) begin
                press_button(4'd1, 10); // KEYB (up)
            end
            
            // Press entry button to confirm digit
            press_button(4'd3, 10); // KEYD (entry)
            
            $display("Time=%0t: Digit entered, hexx_y = %h", $time, hexx_y);
        end
    endtask

    // Task to display current system state
    task display_state;
        begin
            $display("Time=%0t: RLED=%b GLED=%b HEX=%h Mode=%b", 
                     $time, rledx, gledx, hexx_y, uut.mode_signal);
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize waveform dump
        $dumpfile("DigitalLockSystem_tb.vcd");
        $dumpvars(0, DigitalLockSystem_tb);
        
        // Initialize all inputs - ACTIVE-LOW: buttons idle at 1 (HIGH)
        swx_n = 1;     // Reset inactive (HIGH)
        swm = 1;       // Normal mode (inverted: internal sees 0)
        keya = 1;      // Buttons idle at HIGH
        keyb = 1;
        keyc = 1;
        keyd = 1;
        
        // Initialize previous state tracking
        prev_rledx = 0;
        prev_gledx = 0;
        
        $display("========================================");
        $display("Digital Lock System Testbench Starting");
        $display("ACTIVE-LOW Button Configuration (DE2 Board)");
        $display("Default Password: 2019");
        $display("========================================");
        
        // System Reset
        // $display("\n--- System Reset ---");
        // swx_n = 0;  // Assert reset (active-low)
        // repeat (10) @(posedge clk);
        // swx_n = 1;  // Deassert reset
        // repeat (10) @(posedge clk);
        // $display("After Reset: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        repeat(20) @(posedge clk);
        // Test sequence
        $display("\n--- Manual Entry Test ---");
        
        // Increment twice (0→1→2)
        press_button(4'd1, 10); // KEYB increment 
        repeat(10) @(posedge clk);
        $display("After 1st UP: hexx_y=%h", hexx_y);
        
        press_button(4'd1, 10);
        repeat(10) @(posedge clk);
        $display("After 2nd UP: hexx_y=%h", hexx_y);

        // Enter digit
        press_button(4'd3, 10);
        repeat(10) @(posedge clk);
        $display("After 1st ENTRY: hexx_y=%h", hexx_y);
        
        // Enter 0 (no increment needed if display is at 0)
        press_button(4'd3, 10);
        repeat(10) @(posedge clk);
        $display("After 2nd ENTRY: hexx_y=%h", hexx_y);
        
        // Increment once (0→1)
        press_button(4'd1, 10);
        repeat(10) @(posedge clk);
        $display("After 3rd UP: hexx_y=%h", hexx_y);
        
        press_button(4'd3, 10);
        repeat(10) @(posedge clk);
        $display("After 3rd ENTRY: hexx_y=%h", hexx_y);

        // Decrement once (for testing down button)
        press_button(4'd2, 10);
        repeat(10) @(posedge clk);
        $display("After DOWN: hexx_y=%h", hexx_y);
        
        // Validate with KEYA
        $display("\n--- Validating Code ---");
        press_button(4'd0, 10);
        repeat(10) @(posedge clk);
        $display("After KEYA: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        // Enter Programming Mode
        $display("\n--- Programming Mode Test ---");
        swm = 0;  // Switch to programming mode (inverted: internal sees 1)
        repeat(10) @(posedge clk);
        $display("Programming mode: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        press_button(4'd0, 10);
        repeat(10) @(posedge clk);
        $display("After KEYA in prog mode: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        // Exit Programming Mode
        swm = 1;  // Back to normal mode (inverted: internal sees 0)
        repeat(20) @(posedge clk);
        $display("Exited programming mode: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        // Lock system
        $display("\n--- Lock System ---");
        press_button(4'd0, 10);
        repeat(10) @(posedge clk); 
        $display("After lock: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        press_button(4'd0, 10);
        repeat(20) @(posedge clk);
        $display("After another KEYA: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        swx_n = 0; 
        repeat(10) @(posedge clk);
        $display("reset pressed");

        swx_n = 1;
        repeat(10) @(posedge clk);

        // Increment twice (0→1→2)
        press_button(4'd1, 10); // KEYB increment 
        repeat(10) @(posedge clk);
        $display("After 1st UP: hexx_y=%h", hexx_y);
        
        press_button(4'd1, 10);
        repeat(10) @(posedge clk);
        $display("After 2nd UP: hexx_y=%h", hexx_y);

        // Enter digit
        press_button(4'd3, 10);
        repeat(10) @(posedge clk);
        $display("After 1st ENTRY: hexx_y=%h", hexx_y);
        
        // Enter 0 (no increment needed if display is at 0)
        press_button(4'd3, 10);
        repeat(10) @(posedge clk);
        $display("After 2nd ENTRY: hexx_y=%h", hexx_y);
        
        // Increment once (0→1)
        press_button(4'd1, 10);
        repeat(10) @(posedge clk);
        $display("After 3rd UP: hexx_y=%h", hexx_y);
        
        press_button(4'd3, 10);
        repeat(10) @(posedge clk);
        $display("After 3rd ENTRY: hexx_y=%h", hexx_y);

        // Decrement once (for testing down button)
        press_button(4'd2, 10);
        repeat(10) @(posedge clk);
        $display("After DOWN: hexx_y=%h", hexx_y);
        
        // Validate with KEYA
        $display("\n--- Validating Code ---");
        press_button(4'd0, 10);
        repeat(10) @(posedge clk);
        $display("After KEYA: hexx_y=%h RLED=%b GLED=%b", hexx_y, rledx, gledx);

        $display("\n========================================");
        $display("Testbench Complete - Check waveform for details");
        $display("========================================");
        
        repeat(50) @(posedge clk);
        $finish;
    end

    // Timeout watchdog
    initial begin
        #2000000; // 2ms timeout
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    // Monitor for LED changes
    always @(posedge clk) begin
        prev_rledx <= rledx;
        prev_gledx <= gledx;
        
        if (rledx !== prev_rledx || gledx !== prev_gledx) begin
            $display("Time=%0t: LED CHANGE - RLED=%b GLED=%b", $time, rledx, gledx);
        end
    end
    
    // Monitor for hex display changes
    always @(hexx_y) begin
        $display("Time=%0t: hexx_y CHANGED to %h (hex) = %d (decimal)", $time, hexx_y, hexx_y);
    end

endmodule