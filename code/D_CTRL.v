module D_CTRL(
    input  logic       clk,
    input  logic       rst,
    input  logic       ud,
    output logic [3:0] Q
);
    /*
    4-bit Syncronous Up/Down 0-9 Digit Counter

    Clock: Rising Edge Triggered (CLK↑)
    Inputs:
        UD: (Up/Down)
        rst: (Reset)
        clk: (clock)
    
    outputs: 
        Q[3:0]: represnts the 4 bit binary 
                digit current for count
    */

    // State type and values
    typedef enum logic [3:0] {
        s0 = 4'b0000,
        s1 = 4'b0001,
        s2 = 4'b0010,
        s3 = 4'b0011,
        s4 = 4'b0100,
        s5 = 4'b0101,
        s6 = 4'b0110,
        s7 = 4'b0111,
        s8 = 4'b1000,
        s9 = 4'b1001
    } state_t;

    state_t state, next_state;

    // ----------------------------------------
    // Block 1: Sequential state register: perform state change on 
    //          clock positive edge or on rst posedge
    // ---------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= s0;
        else
            state <= next_state;
    end

    // ---------------------------------------
    // Block 2: Next-state combinational logic
    // ---------------------------------------
    always_comb begin
        next_state = state; // default to avoid inferred latches
        case (state)
            s0: next_state = ud ? s1 : s9;
            s1: next_state = ud ? s2 : s0;
            s2: next_state = ud ? s3 : s1;
            s3: next_state = ud ? s4 : s2;
            s4: next_state = ud ? s5 : s3;
            s5: next_state = ud ? s6 : s4;
            s6: next_state = ud ? s7 : s5;
            s7: next_state = ud ? s8 : s6;
            s8: next_state = ud ? s9 : s7;
            s9: next_state = ud ? s0 : s8;
            default: next_state = s0;
        endcase
    end

    // ----------------------------------
    // BLOCK 3: Moore Output Logic
    // ----------------------------------
    always_comb begin
        case (state)
            s0: Q = 4'b0000; 
            s1: Q = 4'b0001;
            s2: Q = 4'b0010;
            s3: Q = 4'b0011;
            s4: Q = 4'b0100;
            s5: Q = 4'b0101;
            s6: Q = 4'b0110;
            s7: Q = 4'b0111;
            s8: Q = 4'b1000;
            s9: Q = 4'b1001;
        endcase
    end 
endmodule
