// =========================
// Code Entry Sub Module
// =========================
/*
CodeEntry Module
Contains several sub modules: 
    - ModeChangeDetector
    - DirectionLogic
    - SinglePulse
    - UpDownCounterWrap
    - CodeShiftRegister

inputs: 
    - clk, rst_n, current_mode
    - keyb_s, keyc_s, keyd_s (up, down, shift buttons)

outputs: 
    - code: 16-bit code being entered
*/
module CodeEntry(
    input wire clk,
    input wire rst_n,
    input wire [1:0] current_mode, 
    input wire keyb_s,
    input wire keyc_s,
    input wire keyd_s,
    output wire [15:0] code
);
    /*
        top level of code entry module, 
        this module manages logic revolving around the code 
        entry for the digital system.
    */

    wire direction_logic_valid;
    wire direction_logic_dir;
    wire single_pulse_out;
    wire [3:0] counter_digit;
    wire mode_change_reset;
    wire rst_code_shift_register_inst_n = rst_n & !mode_change_reset;
	 
	 wire counter_clear = keyd_s | mode_change_reset;

    ModeChangeDetector mode_change_detector_inst(
        .clk(clk),
        .rst_n(rst_n), 
        .current_mode(current_mode),
        .is_mode_change(mode_change_reset)
    );
    DirectionLogic direction_logic_inst(
        .up(keyb_s),
        .down(keyc_s),
        .dir(direction_logic_dir),
        .valid(direction_logic_valid)
    );
    SinglePulse single_pulse_inst(
        .clk(clk),
        .rst_n(rst_n),
        .trigger(direction_logic_valid),
        .pulse(single_pulse_out)
    );
    UpDownCounterWrap up_down_counter_inst(
        .clk(clk),
        .rst_n(rst_n),
		  .clear(counter_clear),
        .ud(direction_logic_dir),
        .trigger(single_pulse_out),
        .count(counter_digit)
    );
    CodeShiftRegister code_shift_register_inst(
        .digit(counter_digit),
        .rst_n(rst_code_shift_register_inst_n),
        .shift(keyd_s),
        .clk(clk),
        .code(code)
    );
endmodule
