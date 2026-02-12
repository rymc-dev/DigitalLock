onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix binary /ModeController_tb/unlock
add wave -noupdate -format Literal -radix binary /ModeController_tb/swx_n
add wave -noupdate -format Literal -radix binary /ModeController_tb/swm
add wave -noupdate -format Literal -radix binary /ModeController_tb/keya
add wave -noupdate /ModeController_tb/clk
add wave -noupdate /ModeController_tb/rledx
add wave -noupdate /ModeController_tb/gledx
add wave -noupdate -radix binary /ModeController_tb/mode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50220 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {266112 ps}
