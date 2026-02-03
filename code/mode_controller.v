module mode_controller(
    input       unlock,
    input       swx_n,      // active-low reset
    input       swm,
    input       keya,
    input       clk,
    output reg  rledx,
    output reg  gledx,
    output reg [1:0] mode
);

    // ----------------------
    // 1. State encoding
    // ----------------------
    localparam LOCKED               = 2'b00,
               UNLOCKED             = 2'b01,
               UNLOCKED_PROGRAMMING = 2'b10;

    reg [1:0] state, next_state;

    // ----------------------
    // 2. State register
    // ----------------------
    always @(posedge clk or negedge swx_n) begin
        if (!swx_n)
            state <= LOCKED;
        else
            state <= next_state;
    end

    // ----------------------
    // 3. Next-state logic
    // ----------------------
    always @(*) begin
        next_state = state;

        case (state)

            // ------------------------------------
            // LOCKED (00)
            // ------------------------------------
            LOCKED: begin
                // unlock = 1 → go to UNLOCKED
                if (unlock)
                    next_state = UNLOCKED;
            end

            // ------------------------------------
            // UNLOCKED (01)
            // ------------------------------------
            UNLOCKED: begin
                // KEYA = 1 → return to LOCKED
                if (keya)
                    next_state = LOCKED;

                // SWM = 1 → enter programming mode
                else if (swm)
                    next_state = UNLOCKED_PROGRAMMING;
            end

            // ------------------------------------
            // UNLOCKED_PROGRAMMING (10)
            // ------------------------------------
            UNLOCKED_PROGRAMMING: begin
                // KEYA = 1 → return to LOCKED
                if (keya)
                    next_state = LOCKED;

                // SWM = 1 → exit programming to UNLOCKED
                else if (swm)
                    next_state = UNLOCKED;
            end

        endcase
    end

    // ----------------------
    // 4. Moore Output Logic
    // ----------------------
    always @(*) begin
        mode = state;

        case (state)
            LOCKED: begin
                gledx = 0;
                rledx = 1;
            end

            UNLOCKED: begin
                gledx = 1;
                rledx = 0;
            end

            UNLOCKED_PROGRAMMING: begin
                gledx = 1;
                rledx = 1;
            end

            default: begin
                gledx = 0;
                rledx = 0;
            end
        endcase
    end

endmodule
