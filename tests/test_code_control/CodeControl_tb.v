`timescale 1ns/1ps

module CodeControl_tb;

    // Inputs
    reg [1:0] current_mode;
    reg [15:0] current_code;
    reg keya;
    reg rst_n;
    reg clk;

    // Output
    wire unlock;

    // Instantiate DUT
    CodeControl dut (
        .current_mode(current_mode),
        .current_code(current_code),
        .keya(keya),
        .rst_n(rst_n),
        .clk(clk),
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
        rst_n = 0;
        current_mode = 2'b00;
        current_code = 16'h0000;
        keya = 0;

        #20;
        rst_n = 1; // Release reset

        // -------------------------------
        // Test 1: UNLOCK mode, correct code, key press → unlock pulse
        // -------------------------------
        @(posedge clk);
        current_mode = 2'b01;        // Assume 01 = UNLOCK mode
        current_code = 16'h2019;     // matches default stored password
        keya = 1;                     // press key

        @(posedge clk);
        keya = 0;                     // release key

        #20;

        // -------------------------------
        // Test 2: UNLOCK mode, wrong code → no unlock
        // -------------------------------
        @(posedge clk);
        current_code = 16'h1234;
        keya = 1;

        @(posedge clk);
        keya = 0;

        #20;

        // -------------------------------
        // Test 3: PROGRAM mode → should not unlock even if code matches
        // -------------------------------
        @(posedge clk);
        current_mode = 2'b10;        // Assume 10 = PROGRAM mode
        current_code = 16'h2019;
        keya = 1;

        @(posedge clk);
        keya = 0;

        #20;

        // -------------------------------
        // Test 4: Reset during operation
        // -------------------------------
        @(posedge clk);
        current_mode = 2'b01;
        current_code = 16'h2019;
        keya = 1;

        @(posedge clk);
        rst_n = 0;  // async reset

        @(posedge clk);
        rst_n = 1;
        keya = 0;

        #50;

        $finish;
    end

    // Simple monitor to observe signals
    initial begin
        $monitor("Time=%0t | rst_n=%b mode=%b code=%h keya=%b | unlock=%b",
                 $time, rst_n, current_mode, current_code, keya, unlock);
    end

endmodule
