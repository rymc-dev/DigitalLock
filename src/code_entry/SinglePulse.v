module SinglePulse(
	input wire clk,
	input wire rst_n,
	input wire trigger,
	output reg pulse
);
	/*
		A one shot pulse which will fire a single pulse
		from the direction logic when trigger is received
	*/
	reg trigger_d;
	
	// delay input by one clock to detect rising edge
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			trigger_d <= 1'b0;
		else
			trigger_d <= trigger;
	end 
	
	// generate pulse on rising edge of trigger
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			pulse <= 1'b0;
		end
		else begin
			pulse <= trigger & ~trigger_d;
		end
	end
endmodule