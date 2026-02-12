# CodeControl Module Tests

This directory contains unit tests for the sub moudules of this CodeControl module one of the three main modules of the digital lock system in verilog.

## Unit Tests

TODO: 
-   CurrentCodeRegistry_tb: Done 
-   ModeDecoder_tb: 
-   CodeEqualityChecker_tb: Done
-   UnlockLogic_tb: Done


CodeControl_tb
```bash
vlib work
vlog 
```

ModeDecoder_tb
```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_control/ModeDecoder_tb.v
vsim ModeDecoder_tb 
```

UnlockLogic_tb
```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_control/UnlockLogic_tb.v
vsim UnlockLogic_tb 
```

ModeDecoder_tb: 
```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_control/ModeDecoder_tb.v
vsim ModeDecoder_tb 
```

CurrentCodeRegistry_tb: 
```bash 
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_control/CurrentCodeRegistry_tb.v
vsim CurrentCodeRegistry_tb 
run 500ns
```
CodeEqualityChecker_tb:
```bash
vlib work
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_control/CodeEqualityChecker_tb.v
vsim CodeEqualityChecker_tb 
run 500ns
```

## Integration Tests

- CodeControl_tb: Done


```bash
vlib work 
vlog C:/Users/ryanm/OneDrive/Desktop/ELEC473-Assignment_1/tests/test_code_control/CodeControl_tb.v
vsim CodeControl_tb 
```