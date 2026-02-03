/*
CodeEntry Module
Contains several sub modules: 
	- PreviousModeRegister
	- ModeChangeDetector
	- DirectionLogic
	- UDCounter 
	- SinglePulsar
	- CodeRegister
	
	
	
inputs: 
	- ...
	
outputs: 
	- ... 
	
Test bench can be found at: 
	... 
*/


module CodeEntry(
	input wire clk,
	input wire rst_n,
	input wire [1:0] current_mode, 
	input wire keyb_s,
	input wire keyc_s,
	input wire keyd_s,
	output wire [15:0] code
);
	/*
		top level of code entry module, 
		this module manages logic revolving around the code 
		entry for the digital system.
		
		inputs :
		.. 
		
		outputs: 
		
			... 
	*/
	
	wire direction_logic_valid_to_single_pulsar;
	wire direction_logic_dir_to_ud_counter;
	wire up_down_counter_wrap_digit_to_code_registry;
	wire mode_change_detector_to_code_register_reset;
	
	mode_change_detector ModeChangeDetector(
		.clk(clk),
		.rst_n(), 
		.current_mode(),
		.is_mode_change()
	);
	
	direction_logic DirectionLogic(
		.up(),
		.down(),
		.dir(),
		.valid()
	);
	
	single_pulse SinglePulse(
		.clk(clk),
		.rst_n(),
		.trigger(),
		.pulse()
	);
	
	up_down_counter UpDownCounterWrap(
		.clk(clk),
		.rst_n(),
		.ud(),
		.trigger(),
		.count()
	);
	
	code_shift_register CodeShiftRegister(
		.digit(),
		.rst(),
		.shift(),
		.clk(clk),
		.code()
	);
endmodule

module ModeChangeDetector(
	input clk,
	input rst_n,
	input [1:0] current_mode,
	output is_mode_change
);
	reg [1:0] previous_mode;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin 
			current_mode <= 2'b00;
			is_mode_change <= 1'b0;
		else if (current_mode != previous_mode) begin
			previous_mode <= current_mode;
			is_mode_change <= 1'b1;
		else 
			is_mode_change <= 1'b0;
		end
	end
endmodule

module DirectionLogic(
	input up,
	input down,
	output dir,
	output valid
);
	/* 
		Truth table which continuously outputs
		direction inputted from buttons for up/down
		counter as well as if the output is valid, valid determines the counter
	*/

	assign DIR_UP = 1'b1;
	assign DIR_DOWN = 1'b0;
	assign DIR_X = 1'bx;
	
	assign IS_VALID = 1'b1;
	assign NOT_VALID = 1'b0;
	
	always @(*)
		casex({up, down})
			2'b00: begin
				dir = x;
				valid = NOT_VALID;
			end
			2'b01: begin
				dir = DIR_DOWN;
				valid = VALID;
			end
			2'b10: begin
				dir = DIR_UP;
				valid = VALID;
			end
			2'b11: begin
				dir = DIR_X;
				valid = NOT_VALID;
			end
			default: begin
				dir = DIR_X;
				valid = NOT_VALID;
			end
		endcase
	end
endmodule

module SinglePulse(
	input wire clk,
	input wire rst_n,
	input wire trigger,
	output reg pulse
);
	/*
		A one show pulse which will will fire a single up down 
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
		else
			pulse <= trigger & ~trigger_d;
	end

endmodule


module UpDownCounterWrap(
	input wire clk,
	input wire rst,
	input wire ud,
	input wire trigger,
	output reg [3:0] count
);
	/*
		up down counter is a simple wrap around counter which
		on rising clock edge when a trigger is recieved we increment
		or decrement the count based on the input from ud representing up down, this 
		is utilized for increments/decrementing the value of the 4 bit segment of the 
		code register for when we are programming or inputting a new password.
		
		min: 1
		max: 16
		
		inputs: 
			- clk:  
			- rst:  
			- ud: 
			- trigger: 
			
		outputs: 
			- count[3:0]: register storing the current up down count
	*/

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			count <= 4'b0000;
		else if (trigger) begin
			if (ud) begin
				if (count == 4'1111) 
					count <= 4'0000;
				else
					count <= count + 1;
				end else begin
					if (count == 4'b0000)
						count <= 4'1111;
					else
						count <= count - 1'b1;
				end
			end
		end
	end
endmodule

module CodeShiftRegister(
	input [3:0] digit,
	input rst,
	input shift,
	input clk,
	output [15:0]code
);
	/* 
		this combinational logic block stores stores the current register segment
		and shifts the right 4 bits for each shift. this code shift register will store 
		the 
		
		inputs:
			- digit[3:0]
			- rst: neg edge reset for the code register
			- shift: when pressed shifts the current reg bit range 4 to the right or 
			 			wraps around if we are at the last segment
			- clk: the clock which we perform combinations logic on the positive edge of the clock
			
		outputs: 
			- code: 
	*/ 
	reg [4:0] position = 4'b0000;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			position <= 4'b0000;
			code <= {16{1'b0}};
		else if (shift) 
				position <= position + 4;
		else 
			// big endian
			code[position + 4: position] = digit; 
		end
	end
endmodule

