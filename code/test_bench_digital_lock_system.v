`timescale 1ns / 1ps

module digital_lock_system_tb;

    // Testbench signals - these connect to your module
    reg  swx_n;
    reg  swm;
    reg  keya;
    reg  keyb;
    reg  keyc;
    reg  keyd;
    reg  clk;
    wire rledx;
    wire gledx;
    wire [6:0] hexx_y;

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

    // Clock generation - creates a clock that toggles every 10ns (50MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Toggle every 10ns (20ns period = 50MHz)
    end

    // Test stimulus
    initial begin
        // Initialize all inputs
        swx_n = 1;  // Active low, so 1 = not pressed
        swm = 0;
        keya = 0;
        keyb = 0;
        keyc = 0;
        keyd = 0;

        // Display header
        $display("Time\t swx_n swm keya keyb keyc keyd | rledx gledx hexx_y");
        $display("------------------------------------------------------------");

        // Wait for 100ns for global reset
        #100;

        // Test Case 1: Press KEY A
        $display("\n=== Test Case 1: Press KEY A ===");
        #20 keya = 1;
        #40 keya = 0;
        #100;

        // Test Case 2: Press KEY B
        $display("\n=== Test Case 2: Press KEY B ===");
        #20 keyb = 1;
        #40 keyb = 0;
        #100;

        // Test Case 3: Press KEY C
        $display("\n=== Test Case 3: Press KEY C ===");
        #20 keyc = 1;
        #40 keyc = 0;
        #100;

        // Test Case 4: Press KEY D
        $display("\n=== Test Case 4: Press KEY D ===");
        #20 keyd = 1;
        #40 keyd = 0;
        #100;

        // Test Case 5: Toggle switch SWM
        $display("\n=== Test Case 5: Toggle SWM ===");
        #20 swm = 1;
        #200 swm = 0;
        #100;

        // Test Case 6: Press SWX_N (active low)
        $display("\n=== Test Case 6: Press SWX_N ===");
        #20 swx_n = 0;  // Press (active low)
        #40 swx_n = 1;  // Release
        #100;

        // Test Case 7: Sequence of keys (example combination)
        $display("\n=== Test Case 7: Key Sequence A-B-C ===");
        #20 keya = 1; #40 keya = 0; #60;
        keyb = 1; #40 keyb = 0; #60;
        keyc = 1; #40 keyc = 0; #60;

        // Wait and finish
        #500;
        $display("\n=== Simulation Complete ===");
        $finish;
    end

    // Monitor outputs - prints values whenever they change
    initial begin
        $monitor("%t\t %b     %b   %b    %b    %b    %b   |  %b     %b     %h",
                 $time, swx_n, swm, keya, keyb, keyc, keyd, rledx, gledx, hexx_y);
    end

    // Optional: Generate VCD file for waveform viewing
    initial begin
        $dumpfile("digital_lock_system.vcd");
        $dumpvars(0, digital_lock_system_tb);
    end

endmodule