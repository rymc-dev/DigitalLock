`timescale 1ns/1ps

module ModeChangeDetector_tb;

    // ======================
    // Testbench Signals
    // ======================
    reg clk;
    reg rst_n;
    reg [1:0] current_mode;
    wire is_mode_change;

    // ======================
    // DUT
    // ======================
    ModeChangeDetector DUT (
        .clk(clk),
        .rst_n(rst_n),
        .current_mode(current_mode),
        .is_mode_change(is_mode_change)
    );

    // ======================
    // Clock Generator
    // ======================
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period
    end

    // ======================
    // Monitor (debug aid)
    // ======================
    always @(posedge clk) begin
        $display("%0t mode=%b is_mode_change=%b",
                 $time, current_mode, is_mode_change);
    end

    // ======================
    // Test Stimulus
    // ======================
    initial begin
        // ------------------
        // Reset
        // ------------------
        rst_n = 0;
        current_mode = 2'b00;

        repeat (2) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // After reset, no mode change expected
        if (is_mode_change !== 0)
            $fatal("FAIL: is_mode_change asserted after reset");

        // ------------------
        // TEST 1: No change → no pulse
        // ------------------
        repeat (3) @(posedge clk);
        if (is_mode_change !== 0)
            $fatal("FAIL: Mode change detected without mode change");

        // ------------------
        // TEST 2: Single mode change
        // ------------------
        current_mode = 2'b01;
        @(posedge clk);

        if (is_mode_change !== 1)
            $fatal("FAIL: Mode change not detected");

        @(posedge clk);
        if (is_mode_change !== 0)
            $fatal("FAIL: is_mode_change lasted more than 1 cycle");

        // ------------------
        // TEST 3: Hold same mode → no pulse
        // ------------------
        repeat (2) @(posedge clk);
        if (is_mode_change !== 0)
            $fatal("FAIL: False mode change while holding mode");

        // ------------------
        // TEST 4: Consecutive changes
        // ------------------
        current_mode = 2'b10;
        @(posedge clk);
        if (is_mode_change !== 1)
            $fatal("FAIL: Mode change 01→10 not detected");

        current_mode = 2'b11;
        @(posedge clk);
        if (is_mode_change !== 1)
            $fatal("FAIL: Mode change 10→11 not detected");

        @(posedge clk);
        if (is_mode_change !== 0)
            $fatal("FAIL: is_mode_change did not clear");

        // ------------------
        // TEST 5: Change back to original
        // ------------------
        current_mode = 2'b00;
        @(posedge clk);
        if (is_mode_change !== 1)
            $fatal("FAIL: Mode change 11→00 not detected");

        @(posedge clk);
        if (is_mode_change !== 0)
            $fatal("FAIL: is_mode_change stuck high");

        // ------------------
        // Done
        // ------------------
        $display("All ModeChangeDetector tests passed.");
        #50;
        $finish;
    end

endmodule
