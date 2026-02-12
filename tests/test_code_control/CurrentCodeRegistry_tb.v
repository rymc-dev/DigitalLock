`timescale 1ns/1ps

module CurrentCodeRegistry_tb;

    // Testbench signals
    reg [15:0] code;
    reg shift;
    reg rst_n;
    reg clk;
    wire [15:0] stored_code;

    // Instantiate the DUT (Device Under Test)
    CurrentCodeRegistry dut (
        .code(code),
        .shift(shift),
        .rst_n(rst_n),
        .clk(clk),
        .stored_code(stored_code)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        code = 16'h0000;
        shift = 0;
        rst_n = 0;

        // Apply reset
        #10;
        rst_n = 1;  // release reset
        #10;
        $display("After reset: stored_code = %h (expected 2019)", stored_code);

        // Try storing new code without shift
        code = 16'hABCD;
        #10;
        $display("Without shift: stored_code = %h (expected 2019)", stored_code);

        // Store new code with shift
        shift = 1;
        #10;
        $display("With shift: stored_code = %h (expected ABCD)", stored_code);

        // Change code while shift is high
        code = 16'h1234;
        #10;
        $display("With shift: stored_code = %h (expected 1234)", stored_code);

        // Disable shift, code should not change
        shift = 0;
        code = 16'hFFFF;
        #10;
        $display("Shift low: stored_code = %h (expected 1234)", stored_code);

        // Apply reset again
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
        $display("After second reset: stored_code = %h (expected 2019)", stored_code);

        $finish;
    end

endmodule
