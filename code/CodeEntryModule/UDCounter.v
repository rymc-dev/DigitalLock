module UDCounter(
    input clk, 
    input reset, 
    input ud, 
    input trigger, 
    output digit
);
    reg [3:0] digit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit <= 4'd0;
        end
        else if (trigger) begin
            if (ud) begin
                // Count up
                if (digit == 4'd9)
                    digit <= 4'd0;
                else
                    digit <= digit + 1;
            end
            else begin
                // Count down
                if (digit == 4'd0)
                    digit <= 4'd9;
                else
                    digit <= digit - 1;
            end
        end
    end
endmodule