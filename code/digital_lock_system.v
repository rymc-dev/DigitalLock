module digital_lock_system(
    input  swx_n,
    input  swm,
    input  keya,
    input  keyb,
    input  keyc, 
    input  keyd,
    input  clk,
    output rledx,
    output gledx,
    output [6:0] hexx_y
);

    // Internal wire signals
    wire unlock_signal;   // this will come from your code entry module later
    wire [1:0] mode_signal;

    // -----------------------------
    // Instantiate mode_controller
    // -----------------------------
    mode_controller u_mode_controller (
        .unlock (unlock_signal), // **input**
        .swx_n  (swx_n),
        .swm    (swm),
        .keya   (keya),
        .clk    (clk),

        .rledx  (rledx),         // **output**
        .gledx  (gledx),
        .mode   (mode_signal)
    );

    // -----------------------------
    // Instantiate the CodeEntry module
    // (example of how you will hook it in)
    // -----------------------------
    // code_entry u_code_entry (
    //     .keya(keya), .keyb(keyb), .keyc(keyc), .keyd(keyd),
    //     .clk(clk),
    //     .unlock(unlock_signal)   // drives unlock for mode_controller
    // );

    // -----------------------------
    // Instantiate CodeControl module
    // etc...
    // -----------------------------

endmodule
