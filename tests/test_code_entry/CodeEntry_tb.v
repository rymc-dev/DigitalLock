`timescale 1ns/1ps

module CodeEntry_tb;

    // =========================
    // Testbench Signals
    // =========================
    reg clk;
    reg rst_n;
    reg [1:0] current_mode;
    reg keyb_s;
    reg keyc_s;
    reg keyd_s;

    wire [15:0] code;

    // =========================
    // DUT Instantiation
    // =========================
    CodeEntry DUT (
        .clk(clk),
        .rst_n(rst_n),
        .current_mode(current_mode),
        .keyb_s(keyb_s),
        .keyc_s(keyc_s),
        .keyd_s(keyd_s),
        .code(code)
    );

    // =========================
    // Clock Generation
    // =========================
    initial begin
        clk = 0;
        forever #10 clk = ~clk;   // 20ns clock period
    end

    // =========================
    // Waveform Dump (for GTKWave)
    // =========================
    initial begin
        $dumpfile("CodeEntry_tb.vcd");
        $dumpvars(0, CodeEntry_tb);
    end

    // =========================
    // Monitor
    // =========================
    initial begin
        $monitor("T=%0t | rst_n=%b | mode=%b | B=%b C=%b D=%b | code=%h",
                  $time, rst_n, current_mode, keyb_s, keyc_s, keyd_s, code);
    end

    // =========================
    // Test Stimulus
    // =========================
    initial begin

        // -------------------------
        // Initial Conditions
        // -------------------------
        rst_n        = 0;
        current_mode = 2'b00;
        keyb_s       = 0;
        keyc_s       = 0;
        keyd_s       = 0;

        // Release reset
        #25;
        rst_n = 1;

        // =====================================================
        // TEST 1: keyb high → increment digit
        // =====================================================
        #20;
        keyb_s = 1;
        @(posedge clk);
		  #20
        keyb_s = 0;
        @(posedge clk);

        // =====================================================
        // TEST 2: keyc high → decrement digit
        // =====================================================
        #20;
        keyc_s = 1;
        @(posedge clk);
		  #20
        keyc_s = 0;
        @(posedge clk);

        // =====================================================
        // TEST 3: keyb and keyc high together → invalid
        // Code should not change
        // =====================================================
        #20;
        keyb_s = 1;
        keyc_s = 1;
        @(posedge clk);
		  #20
        keyb_s = 0;
        keyc_s = 0;
        @(posedge clk);

        // =====================================================
        // TEST 4: Shift operation
        // 1) Increment
        // 2) Shift
        // 3) Increment again
        // =====================================================
        #20;

        // Increment current digit
        keyb_s = 1;
        @(posedge clk);
			#20; 
			keyb_s = 0;
		
        // Shift
        keyd_s = 1;
        @(posedge clk);
        keyd_s = 0;

        // Increment new digit
        keyb_s = 1;
        @(posedge clk);
        keyb_s = 0;
        @(posedge clk);

        // =====================================================
        // TEST 5: Mode change reset
        // =====================================================
        #20;
        current_mode = 2'b01;   // simulate mode change
        @(posedge clk);

		  #20;
		  keyc_s = 1'b1;
		  @(posedge clk);
		  keyc_s = 1'b1;
		  @(posedge clk);
		  
        // =====================================================
        // TEST 6: Global reset
        // =====================================================
        #20;
        rst_n = 0;
        @(posedge clk);
		  #10;
        rst_n = 1;
        @(posedge clk);

        // Let simulation run a little longer
        #50;

        $finish;
    end

endmodule
