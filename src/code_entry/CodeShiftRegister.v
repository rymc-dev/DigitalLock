module CodeShiftRegister(
    input  [3:0] digit,
    input        rst_n,
    input        shift,
    input        clk,
    output reg [15:0] code
);
    reg [1:0] segment;
    reg shift_d;
    wire shift_posedge;
    
    initial begin 
        code = 16'b0;
        segment = 2'd0;
        shift_d = 1'b0;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_d <= 1'b0;
        else
            shift_d <= shift;
    end
    
    assign shift_posedge = shift & ~shift_d;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            code    <= 16'b0;
            segment <= 2'd0;
        end
        else if (shift_posedge) begin
            code[15 - segment*4 -: 4] <= digit;  // Use digit directly
            if (segment == 2'd3)
                segment <= 2'd0;
            else
                segment <= segment + 1;
        end
        else begin 
            code[15 - segment*4 -: 4] <= digit;  // Live preview
        end
    end
endmodule