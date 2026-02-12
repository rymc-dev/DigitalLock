module ModeChangeDetector(
	input clk,
	input rst_n,
	input [1:0] current_mode,
	output reg is_mode_change
);
	reg [1:0] previous_mode;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin 
			previous_mode <= 2'b00;
			is_mode_change <= 1'b0;
		end
		else if (current_mode != previous_mode) begin
			previous_mode <= current_mode;
			is_mode_change <= 1'b1;
		end
		else begin
			is_mode_change <= 1'b0;
		end
	end
endmodule
