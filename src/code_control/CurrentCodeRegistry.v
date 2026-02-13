// =========================
// CurrentCodeRegistry - FIXED VERSION
// =========================
module CurrentCodeRegistry(
    input wire [15:0] code,
    input wire shift, 
    input wire rst_n,
    input wire clk,
    output reg [15:0] stored_code
);
    /* 
        stores the current programmed password
        default password is 4'd2019 (converted to binary: 0010_0000_0001_1001)
        
        inputs: 
            - code: 16-bit code to be stored when shift is triggered
            - shift: when high (and in programming mode), stores new code
            - rst_n: active-low reset
            - clk: system clock
            
        outputs:     
            - stored_code: the currently stored password
    */
    
    // Default password: 2019 in BCD would be 0x2019
    // But if treating as decimal hex: 2019 = 0x07E3
    // Based on comment "4'd2019", assuming BCD representation
    localparam DEFAULT_PASSWORD = 16'h2019;
    
    // Edge detection for shift signal
    reg shift_d;
    wire shift_posedge;
    
	 initial begin 
		stored_code = DEFAULT_PASSWORD;
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
            stored_code <= DEFAULT_PASSWORD;
        end
        else if (shift_posedge) begin  // FIXED: Only store on rising edge
            stored_code <= code;
        end
    end
    
endmodule
