`timescale 1ns/1ps

module DirectionLogic_tb;

    // ======================
    // Testbench Signals
    // ======================
    reg up;
    reg down;
    wire dir;
    wire valid;

    // ======================
    // DUT
    // ======================
    DirectionLogic DUT (
        .up(up),
        .down(down),
        .dir(dir),
        .valid(valid)
    );

    // ======================
    // Monitor (Debug)
    // ======================
    initial begin
        $monitor("%0t up=%b down=%b | dir=%b valid=%b",
                 $time, up, down, dir, valid);
    end

    // ======================
    // Test Stimulus
    // ======================
    initial begin

        // ------------------
        // TEST 1: 00 → Not Valid
        // ------------------
        up = 0; down = 0;
        #5;
        if (valid !== 0)
            $fatal("FAIL: 00 should be NOT_VALID");

        // ------------------
        // TEST 2: 01 → Down Valid
        // ------------------
        up = 0; down = 1;
        #5;
        if (valid !== 1 || dir !== 0)
            $fatal("FAIL: 01 should be DOWN + VALID");

        // ------------------
        // TEST 3: 10 → Up Valid
        // ------------------
        up = 1; down = 0;
        #5;
        if (valid !== 1 || dir !== 1)
            $fatal("FAIL: 10 should be UP + VALID");

        // ------------------
        // TEST 4: 11 → Not Valid
        // ------------------
        up = 1; down = 1;
        #5;
        if (valid !== 0)
            $fatal("FAIL: 11 should be NOT_VALID");

        // ------------------
        // TEST 5: Rapid toggling
        // ------------------
        repeat (5) begin
            up = $random;
            down = $random;
            #5;
        end

        // ------------------
        // Done
        // ------------------
        $display("All DirectionLogic tests passed.");
        #10;
        $finish;

    end

endmodule
