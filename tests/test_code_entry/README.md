# Tests todo list

Unit Tests 
Unit tests cover the submodules of this CodeEntry Topological module

TODO: COMPLETE
    - CodeShiftRegistry_tb: Completed
    - DirectionLogic_tb: Completed
    - ModeChangeDetector_tb: Completed
    - SinglePulse_tb.v: Completed
    - UpDownCounter_tb.v: Complete


ModelSim run instructions transcript

CodeShiftRegister_tb

```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_entry/CodeShiftRegister_tb.v
vsim CodeShiftRegister_tb 
run 500ns
```

DirectionLogic_tb
```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_entry/DirectionLogic_tb.v
vsim DirectionLogic_tb 
run 500ns
```

ModeChangeDetector_tb
```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_entry/ModeChangeDetector_tb.v
vsim ModeChangeDetector_tb 
run 500ns
```

SinglePulse_tb

```bash
vlib work
vlog "C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_entry/SinglePulse_tb.v"
vsim SinglePulse_tb 
run 500ns
```

UpDownCounter_tb :

```bash
vlib work
vlog "C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_entry/UpDownCounter_tb.v"
vsim UpDownCounterWrap_tb
run 500ns
```



Integration Test:
Integration test is the test bench testing the combinatation of all these modules to ensure functionality is as expected

TODO: 
- CodeEntry_tb: Complete! 

```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_entry/CodeEntry_tb.v
vsim CodeEntry_tb 
run 500ns
```