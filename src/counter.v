module counter(
	input clk, 
	output reg [3:0] count
);
	initial begin 
		count = 4'd0;
	end

	always @(posedge clk) begin
		count <= count + 4'd1;
	end
endmodule