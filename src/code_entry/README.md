# Code Entry

Contains implemenation for code entry management

CodeEntry Module
Contains several sub modules: 
	- ModeChangeDetector
	- DirectionLogic
	- SinglePulse
	- UpDownCounterWrap
	- CodeShiftRegister
	
inputs: 
	- clk, rst_n, current_mode
	- keyb_s, keyc_s, keyd_s (up, down, shift buttons)
	
outputs: 
	- code: 16-bit code being entered