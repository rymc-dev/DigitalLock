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
    wire [1:0] mode_signal;
    
    // Invert active-low inputs to active-high internal signals
    wire swm_int  = ~swm;
    wire keya_int = ~keya;
    wire keyb_int = ~keyb;
    wire keyc_int = ~keyc;
    wire keyd_int = ~keyd;
    
    // -----------------------------
    // Instantiate mode_controller
    ModeController mode_controller_inst (
        .unlock (unlock_signal), 
        .swx_n  (swx_n),
        .swm    (swm_int),       // Use inverted signal
        .keya   (keya_int),      // Use inverted signal
        .clk    (clk),
        .rledx  (rledx),         
        .gledx  (gledx),
        .mode   (mode_signal)
    );
    
    CodeEntry code_entry_inst (
        .clk(clk),               
        .rst_n(swx_n),
        .current_mode(mode_signal),
        .keyb_s(keyb_int),       // Use inverted signal
        .keyc_s(keyc_int),       // Use inverted signal
        .keyd_s(keyd_int),       // Use inverted signal
        
        .code(hexx_y)         
    );
    
    CodeControl code_control_inst(
        .current_mode(mode_signal), 
        .current_code(hexx_y),
        .keya(keya_int),         // Use inverted signal
        .rst_n(swx_n),
        .clk(clk),
        
        .unlock(unlock_signal)     
    );
endmodule