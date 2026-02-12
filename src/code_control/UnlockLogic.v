module UnlockLogic(
	input wire enable_validate,
	input wire match,
	input wire trigger_validate,
	input wire clk,
	input wire rst_n,
	output reg unlock
);
	/* 
		contains unlock logic for the digital system
		
		Logic:
		- When enable_validate is high AND match is high AND trigger_validate is pressed,
		  set unlock to high for one clock cycle (pulse)
		
		inputs: 
			- enable_validate: from ModeDecoder (high in LOCKED/UNLOCKED modes)
			- match: from CodeEqualityChecker (high if codes match)
			- trigger_validate: keya button press
			- clk: system clock
			- rst_n: active-low reset
			
		outputs: 
			- unlock: pulse signal when validation succeeds
	*/ 
	
	reg trigger_validate_d;
	wire trigger_rising_edge;
	
	// Detect rising edge of trigger_validate
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			trigger_validate_d <= 1'b0;
		else
			trigger_validate_d <= trigger_validate;
	end
	
	assign trigger_rising_edge = trigger_validate & ~trigger_validate_d;
	
	// Generate unlock pulse when conditions are met
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			unlock <= 1'b0;
		end
		else begin
			// Unlock if: validation enabled AND codes match AND trigger pressed
			if (enable_validate && match && trigger_rising_edge)
				unlock <= 1'b1;
			else
				unlock <= 1'b0;
		end
	end

endmodule