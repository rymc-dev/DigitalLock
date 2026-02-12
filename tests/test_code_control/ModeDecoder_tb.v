`timescale 1ns/1ps

module ModeDecoder_tb;

    // Testbench signals
    reg  [1:0] mode;
    wire enable_validate;
    wire enable_program;

    // Instantiate the DUT (Device Under Test)
    ModeDecoder uut (
        .mode(mode),
        .enable_validate(enable_validate),
        .enable_program(enable_program)
    );

    // Test sequence
    initial begin
        $display("Time\tmode\tenable_validate\tenable_program");
        $display("-------------------------------------------------------");

        // Test LOCKED (2'b00)
        mode = 2'b00;
        #10;
        $display("%0t\t%b\t%b\t\t%b", $time, mode, enable_validate, enable_program);

        // Test UNLOCKED (2'b01)
        mode = 2'b01;
        #10;
        $display("%0t\t%b\t%b\t\t%b", $time, mode, enable_validate, enable_program);

        // Test UNLOCKED_PROGRAMMING (2'b10)
        mode = 2'b10;
        #10;
        $display("%0t\t%b\t%b\t\t%b", $time, mode, enable_validate, enable_program);

        // Test default case (2'b11)
        mode = 2'b11;
        #10;
        $display("%0t\t%b\t%b\t\t%b", $time, mode, enable_validate, enable_program);

        $display("Test complete.");
        $stop;
    end

endmodule
