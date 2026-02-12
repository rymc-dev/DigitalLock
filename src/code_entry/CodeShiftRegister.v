module CodeShiftRegister(
    input  [3:0] digit,
    input        rst_n,      // active low
    input        shift,
    input        clk,
    output reg [15:0] code
);

    reg [1:0] segment;   // 0–3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            code    <= 16'b0;
            segment <= 2'd0;
        end
        else if (shift) begin
            // Big endian nibble placement
            code[15 - segment*4 -: 4] <= digit;

            if (segment == 2'd3)
                segment <= 2'd0;
            else
                segment <= segment + 1;
        end
		  else begin 
			code[15 - segment*4 -: 4] <= digit;
		  end
    end

endmodule
