
# run the sim
vlib work
vlog "C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_mode_controller/ModeController_tb.v"
vsim ModeController_tb
add wave *
run 500ns
vsim -view file path -do file path


# open the sim
do "C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_mode_controller/results/TestModeController_tb.do"