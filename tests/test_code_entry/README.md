# CodeEntry Sub-Modules Path Coverage Analysis
Complete verification for all CodeEntry sub-modules showing 100% coverage


## Module 1: UpDownCounterWrap

### ASM State Machine


### Path Definitions

| Path # | Condition | Action | Expected Result |
|--------|-----------|--------|-----------------|
| 1 | `!rst_n` | Asynchronous reset | `count = 0` |
| 2 | `trigger = 0` | No action | `count unchanged` |
| 3 | `trigger=1 & ud=1 & count<9` | Increment | `count = count + 1` |
| 4 | `trigger=1 & ud=1 & count=9` | Wrap up | `count = 0` |
| 5 | `trigger=1 & ud=0 & count>0` | Decrement | `count = count - 1` |
| 6 | `trigger=1 & ud=0 & count=0` | Wrap down | `count = 9` |
| 7 | `clear=1` | Synchronous clear | `count = 0` |




## Module 2: SinglePulse

### Edge Detection Logic

```
Input:   ___________╱‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾╲___________
         (trigger)        held high

Delayed: _______________╱‾‾‾‾‾‾‾‾‾‾‾‾‾╲_______
         (trigger_d)    one cycle delay

Pulse:   _______________╱‾╲___________________
         (output)      single cycle
```

### Path Definitions

| Path # | Condition | Expected Output | Purpose |
|--------|-----------|-----------------|---------|
| 1 | `trigger = 0` | `pulse = 0` | No activity when idle |
| 2 | `trigger: 0→1` (rising edge) | `pulse = 1` for 1 cycle | Detect button press |
| 3 | `trigger held high` | `pulse = 0` after first cycle | Prevent retrigger |
| 4 | Multiple `0→1` edges | Multiple pulses | Each press = one pulse |
| 5 | `!rst_n` | `pulse = 0` | Reset clears output |



## Module 3: DirectionLogic

### Combinational Truth Table

```
┌────────┬────────┬─────────┬────────────────────┐
│   up   │  down  │  valid  │  dir  │   Action   │
├────────┼────────┼─────────┼───────┼────────────┤
│   0    │   0    │    0    │   X   │  Invalid   │
│   0    │   1    │    1    │   0   │  Down      │
│   1    │   0    │    1    │   1   │  Up        │
│   1    │   1    │    0    │   X   │  Conflict  │
└────────┴────────┴─────────┴───────┴────────────┘
```

### Path Definitions

| Path # | Input (up, down) | Expected Output | Meaning |
|--------|------------------|-----------------|---------|
| 1 | `00` | `valid=0, dir=X` | No buttons pressed |
| 2 | `01` | `valid=1, dir=0` | Down button only |
| 3 | `10` | `valid=1, dir=1` | Up button only |
| 4 | `11` | `valid=0, dir=X` | Both pressed (conflict) |



## Module 4: CodeShiftRegister

### Shift Register Operation

```
Segment Position:  [0]  [1]  [2]  [3]
Code bits:         15:12 11:8 7:4  3:0
                   ─────────────────────
Initial:           0    0    0    0
Enter 'A', shift:  A    0    0    0
Enter 'B', shift:  A    B    0    0
Enter 'C', shift:  A    B    C    0
Enter 'D', shift:  A    B    C    D
Enter 'E', shift:  E    B    C    D  (wraps to position 0)
```

### Path Definitions

| Path # | Operation | Expected Behavior |
|--------|-----------|-------------------|
| 1 | `!rst_n` | `code=0000, segment=0` |
| 2 | Change `digit` without `shift` | Live preview (current segment updates) |
| 3 | `shift` posedge | Lock digit, increment segment |
| 4 | 4th shift | Lock digit, wrap segment to 0 |
| 5 | `!rst_n` during operation | Clear code and segment |


## Module 5: CodeEntry (Integration)

### Integration Test Paths

| Path # | Operation | Components Tested | Expected Result |
|--------|-----------|-------------------|-----------------|
| 1 | Press KEYB | DirectionLogic + SinglePulse + Counter | Counter increments |
| 2 | Press KEYC | DirectionLogic + SinglePulse + Counter | Counter decrements |
| 3 | Press both | DirectionLogic (invalid) | No change |
| 4 | Press KEYD | ShiftRegister | Digit shifted, counter cleared |
| 5 | Mode change | ModeChangeDetector + all | All reset |
| 6 | Global reset | All modules | Complete reset |


## Complete Coverage Summary

| Module | Total Paths | Tested | Coverage |
|--------|-------------|--------|----------|
| UpDownCounterWrap | 7 | 7 | 100% ✓ |
| SinglePulse | 5 | 5 | 100% ✓ |
| DirectionLogic | 4 | 4 | 100% ✓ |
| CodeShiftRegister | 5 | 5 | 100% ✓ |
| CodeEntry (integration) | 6 | 6 | 100% ✓ |
| **TOTAL** | **27** | **27** | **100% ✓** |


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