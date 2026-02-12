`timescale 1ns/1ps

module CodeShiftRegister_tb;

    reg  [3:0] digit;
    reg        rst_n;
    reg        shift;
    reg        clk;
    wire [15:0] code;

    // Instantiate DUT
    CodeShiftRegister uut (
        .digit(digit),
        .rst_n(rst_n),
        .shift(shift),
        .clk(clk),
        .code(code)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        $display("Starting simulation...");
        $monitor("Time=%0t | rst=%b shift=%b digit=%h | code=%h",
                  $time, rst, shift, digit, code);

        // Initialize
        clk   = 0;
        rst_n   = 0;   // Assert reset
        shift = 0;
        digit = 4'h0;

        #20;
        rst_n = 1;     // Release reset

        //------------------------------------------------
        // Test 1: Change digit WITHOUT shift
        //------------------------------------------------
        #10 digit = 4'hA; shift = 0;
        #20;  // wait two clock edges

        // Code should still be 0000

        //------------------------------------------------
        // Test 2: Now shift it in
        //------------------------------------------------
        #10 shift = 1;
        #10 shift = 0;

        // Now A should appear in first segment

        //------------------------------------------------
        // Test 3: Change digit again WITHOUT shift
        //------------------------------------------------
        #10 digit = 4'hB;
        #20;

        // Code should remain unchanged

        //------------------------------------------------
        // Test 4: Shift again
        //------------------------------------------------
        #10 shift = 1;
        #10 shift = 0;
		  #10 shift = 1;
		  #10 shift = 0; 
		  #10 shift = 1; 
		  #10 shift = 0;
		  #10 digit = 4'b1111;
		  #10 shift = 1;
		  #10 shift = 0;
		  
		  #10 rst_n = 0;
		  
		  #10 shift = 0; 
		 
        #40;

        $display("Simulation finished.");
        $finish;
    end

endmodule
