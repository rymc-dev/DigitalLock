`timescale 1ns/1ps

module UnlockLogic_tb;

    // Testbench signals
    reg enable_validate;
    reg match;
    reg trigger_validate;
    reg clk;
    reg rst_n;
    wire unlock;

    // Instantiate DUT
    UnlockLogic dut (
        .enable_validate(enable_validate),
        .match(match),
        .trigger_validate(trigger_validate),
        .clk(clk),
        .rst_n(rst_n),
        .unlock(unlock)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize
        enable_validate = 0;
        match = 0;
        trigger_validate = 0;
        rst_n = 0;

        // Apply reset
        #20;
        rst_n = 1;

        // ----------------------------------------
        // TEST 1: All conditions true → expect pulse
        // ----------------------------------------
        @(posedge clk);
        enable_validate = 1;
        match = 1;

        @(posedge clk);
        trigger_validate = 1;   // rising edge

        @(posedge clk);
        trigger_validate = 0;   // release button

        // ----------------------------------------
        // TEST 2: No match → no pulse
        // ----------------------------------------
        @(posedge clk);
        match = 0;

        @(posedge clk);
        trigger_validate = 1;

        @(posedge clk);
        trigger_validate = 0;

        // ----------------------------------------
        // TEST 3: enable_validate low → no pulse
        // ----------------------------------------
        @(posedge clk);
        match = 1;
        enable_validate = 0;

        @(posedge clk);
        trigger_validate = 1;

        @(posedge clk);
        trigger_validate = 0;

        // ----------------------------------------
        // TEST 4: Hold trigger high → only one pulse
        // ----------------------------------------
        @(posedge clk);
        enable_validate = 1;
        match = 1;

        @(posedge clk);
        trigger_validate = 1;   // rising edge

        repeat (3) @(posedge clk);  // hold high

        trigger_validate = 0;

        // ----------------------------------------
        // TEST 5: Reset during operation
        // ----------------------------------------
        @(posedge clk);
        trigger_validate = 1;

        @(posedge clk);
        rst_n = 0;  // async reset

        @(posedge clk);
        rst_n = 1;
        trigger_validate = 0;

        #50;
        $finish;
    end

    // Simple monitor
    initial begin
        $monitor("Time=%0t | rst_n=%b enable=%b match=%b trig=%b | unlock=%b",
                  $time, rst_n, enable_validate, match, trigger_validate, unlock);
    end

endmodule
