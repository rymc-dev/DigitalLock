`timescale 1ns/1ps

module CodeEqualityChecker_tb;

    // Signals
    reg [15:0] a;
    reg [15:0] b;
    wire match;

    // Instantiate DUT
    CodeEqualityChecker dut (
        .a(a),
        .b(b),
        .match(match)
    );

    initial begin
        // Initialize inputs
        a = 16'h0000;
        b = 16'h0000;

        #5; // wait for initialization

        // Test 1: equal
        a = 16'h1234;
        b = 16'h1234;
        #10; // allow signals to propagate
        $display("Test 1: a=%h b=%h match=%b (expected 1)", a, b, match);

        // Test 2: different
        a = 16'hABCD;
        b = 16'h1234;
        #10;
        $display("Test 2: a=%h b=%h match=%b (expected 0)", a, b, match);

        // Test 3: another match
        a = 16'hFFFF;
        b = 16'hFFFF;
        #10;
        $display("Test 3: a=%h b=%h match=%b (expected 1)", a, b, match);

        $finish;
    end

endmodule
