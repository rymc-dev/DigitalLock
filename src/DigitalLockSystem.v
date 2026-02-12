/** 
A digital FPGA design for a locking system
the top level module being digital_lock_system with
several different configurations depending on input.
**/

module DigitalLockSystem(
    input  swx_n,
    input  swm,
    input  keya,
    input  keyb,
    input  keyc, 
    input  keyd,
    input  clk,
    output rledx,
    output gledx,
    output [15:0] hexx_y
);

    // Internal wire signals
    wire unlock_signal;

    // -----------------------------
    // Instantiate mode_controller
	 
	 wire [1:0] mode_signal;
	 
    ModeController mode_controller_inst (
        .unlock (unlock_signal), 
        .swx_n  (swx_n),
        .swm    (swm),
        .keya   (keya),
        .clk    (clk),

        .rledx  (rledx),         
        .gledx  (gledx),
        .mode   (mode_signal)
    );
	 
	 CodeEntry code_entry_inst (
        .clk(clk),               
        .rst_n(swx_n),
        .current_mode(mode_signal),
        .keyb_s(keyb),
        .keyc_s(keyc),
        .keyd_s(keyd),
        
        .code(hexx_y)         
	 );
	 
	 CodeControl code_control_inst(
        .current_mode(mode_signal), 
        .current_code(hexx_y),
        .keya(keya),
        .rst_n(swx_n),
        .clk(clk),
        
        .unlock(unlock_signal)     
	 );
 endmodule
