# Digital Lock System - ELEC473 Assignment

A fully synchronous FPGA-based electronic safe controller designed for the Altera DE2 board using Verilog HDL.

## Project Overview

This digital lock system implements a secure 4-digit electronic safe with programmable password functionality. The design uses a hierarchical modular architecture with proper edge detection and fully synchronous operation.

**Course:** ELEC473 - Digital Systems Design  
**Institution:** University of Liverpool  
**Academic Year:** 2025-2026  
**Development Platform:** Quartus II V13.0-SP1  
**Target Hardware:** Altera DE2 Development Board

---

## Features

✅ **Secure 4-Digit Code Entry** - Decimal digits (0-9) with live preview  
✅ **Password Validation** - Compares entered code with stored password  
✅ **Programmable Passwords** - Change combination when unlocked  
✅ **Default Password Reset** - Returns to student ID on system reset  
✅ **Visual Feedback** - LED indicators for locked/unlocked/programming states  
✅ **Fully Synchronous Design** - Proper edge detection on all inputs  
✅ **Active-Low Button Support** - Compatible with DE2 board hardware  

**Default Password:** 2019 (last 4 digits of student ID)

---

## System Architecture

### Block Diagram
```
┌─────────────────────────────────────────────────────────┐
│              DigitalLockSystem (Top Level)              │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────┐   ┌──────────────┐   ┌────────────┐ │
│  │              │   │              │   │            │ │
│  │     Mode     │◄──┤     Code     │◄──┤    Code    │ │
│  │  Controller  │   │    Control   │   │   Entry    │ │
│  │     (FSM)    │   │ (Validation) │   │ (Input)    │ │
│  │              │   │              │   │            │ │
│  └──────┬───────┘   └──────▲───────┘   └─────▲──────┘ │
│         │                  │                  │        │
│      mode_signal     unlock_signal      hexx_y (code)  │
│                                                         │
└─────────────────────────────────────────────────────────┘
         │                                         │
    LEDs Output                              Display Output
```

### Module Hierarchy

**Top Level:**
- `DigitalLockSystem` - System integration and signal conversion

**Level 1 Modules:**
1. `ModeController` - Main FSM (3 states)
2. `CodeEntry` - Code entry system
3. `CodeControl` - Password validation and storage

**Level 2 Modules (CodeEntry sub-modules):**
- `DirectionLogic` - Button decoder
- `SinglePulse` - Edge detector
- `UpDownCounterWrap` - Digit selector (0-9)
- `ModeChangeDetector` - Mode transition detector
- `CodeShiftRegister` - 4-digit storage with live preview

**Level 2 Modules (CodeControl sub-modules):**
- `ModeDecoder` - Operation enable logic
- `CurrentCodeRegistry` - Password storage
- `CodeEqualityChecker` - 16-bit comparator
- `UnlockLogic` - Validation logic

**Total:** 15 modules

---

## Hardware Interface

### Inputs (DE2 Board)
| Signal | Hardware | Function | Active |
|--------|----------|----------|--------|
| `clk` | CLOCK_50 | 50MHz system clock | - |
| `swx_n` | SW[17] | System reset | Low |
| `swm` | SW[16] | Programming mode switch | Low |
| `keya` | KEY[0] | Lock/Restart button | Low |
| `keyb` | KEY[1] | Up button (increment) | Low |
| `keyc` | KEY[2] | Down button (decrement) | Low |
| `keyd` | KEY[3] | Enter/Shift button | Low |

### Outputs (DE2 Board)
| Signal | Hardware | Function | Active |
|--------|----------|----------|--------|
| `rledx` | LEDR[0] | Locked indicator | High |
| `gledx` | LEDG[0] | Unlocked indicator | High |
| `hexx_y` | HEX3-0 | 4-digit display (16 bits) | High |

### LED Status Indicators
| State | Red LED | Green LED | Meaning |
|-------|---------|-----------|---------|
| LOCKED | ON | OFF | System locked |
| UNLOCKED | OFF | ON | System unlocked |
| PROGRAMMING | ON | ON | Programming mode |

---

## Operation Guide

### Initial Setup
1. **System Reset**: Press SWX (SW[17]) to initialize
2. **Default State**: System starts LOCKED with red LED on
3. **Display**: Shows "0000" initially

### Entering a Code
1. Press **KEYA** to lock system (if not already locked)
2. Use **KEYB** (up) or **KEYC** (down) to select first digit (0-9)
3. Press **KEYD** to enter digit and move to next position
4. Repeat for all 4 digits
5. System automatically validates after 4th digit

### Unlocking
- If code matches stored password → Green LED turns ON
- If code incorrect → Red LED stays ON

### Programming New Password
1. Unlock the system with correct password
2. Toggle **SWM** switch ON (both LEDs light up)
3. Enter new 4-digit password using KEYB/KEYC/KEYD
4. Press **KEYA** to save new password
5. Toggle **SWM** switch OFF to exit programming mode
6. Lock system and test new password

### Reset to Default
- Press **SWX** to reset system
- Password returns to default: **2019**

---

## State Machine (ModeController)

### States
```
┌─────────────────────────────────────────────────────┐
│                                                     │
│    ┌──────────┐  unlock  ┌────────────┐           │
│    │          │─────────►│            │           │
│    │  LOCKED  │          │  UNLOCKED  │           │
│    │   (00)   │◄─────────│    (01)    │           │
│    │          │  keya    │            │           │
│    └──────────┘          └─────┬──────┘           │
│         ▲                      │                   │
│         │                      │ swm↑              │
│         │                      ▼                   │
│         │               ┌─────────────┐            │
│         │               │  UNLOCKED   │            │
│         └───────────────┤ PROGRAMMING │            │
│            keya         │    (10)     │            │
│                         └─────────────┘            │
│                               │  ▲                 │
│                               └──┘ swm↓            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### State Encoding
- `LOCKED (00)` - Red LED on, system locked
- `UNLOCKED (01)` - Green LED on, system unlocked
- `UNLOCKED_PROGRAMMING (10)` - Both LEDs on, programming mode

---

## File Structure

```
DigitalLockSystem/
│
├── DigitalLockSystem_COMMENTED.v     # Top-level module
├── ModeController_COMMENTED.v         # Main FSM controller
├── CodeEntry_REFACTORED.v             # Code entry system (6 modules)
├── CodeControl_REFACTORED.v           # Password control (5 modules)
│
├── tests/
│   └── DigitalLockSystem_tb.v         # Testbench for simulation
│
├── docs/
│   ├── block_diagrams/                # System architecture diagrams
│   ├── asm_charts/                    # ASM state machine charts
│   └── simulation_results/            # Annotated waveforms
│
└── README.md                          # This file
```

---

## Module Details

### DigitalLockSystem (Top Level)
**Purpose:** System integration and active-low to active-high conversion  
**Inputs:** 7 (clock, reset, mode switch, 4 buttons)  
**Outputs:** 3 (2 LEDs, 16-bit display)  
**Function:** Converts DE2 board active-low signals to active-high for internal logic

### ModeController
**Type:** Finite State Machine (Moore)  
**States:** 3 (LOCKED, UNLOCKED, UNLOCKED_PROGRAMMING)  
**Function:** Controls system state transitions and LED outputs  
**Key Feature:** Edge detection on KEYA and SWM prevents rapid state changes

### CodeEntry
**Type:** Hierarchical module (6 sub-modules)  
**Function:** Manages digit selection and code entry with live preview  
**Key Features:**
- Up/down counter for digit selection (0-9)
- Shift register for 4-digit storage
- Live preview of current digit
- Mode change detection for resets

### CodeControl
**Type:** Hierarchical module (5 sub-modules)  
**Function:** Password validation and storage  
**Key Features:**
- Default password: 0x2019
- 16-bit equality checker
- Edge-detected password storage
- Mode-dependent operation enables

---

## Design Features

### Edge Detection
All button and switch inputs use proper edge detection to prevent:
- Multiple state transitions from held buttons
- Unwanted counter increments
- Repeated password stores

**Pattern used:**
```verilog
reg signal_delayed;
always @(posedge clk) signal_delayed <= signal;
wire signal_posedge = signal & ~signal_delayed;
```

### Synchronous Design
- All registers update on `posedge clk`
- Asynchronous reset on `negedge swx_n`
- No combinational loops
- Proper reset initialization

### Wrap-Around Counter
- Counts 0→9 (wraps to 0)
- Counts 9→0 (wraps to 9)
- Synchronous clear on mode change or digit shift

---

## Simulation

### Testbench
- Comprehensive testbench provided: `DigitalLockSystem_tb.v`
- Tests all functional requirements
- Annotated for report documentation

### Test Cases Covered
1. ✅ System reset
2. ✅ Lock/unlock functionality
3. ✅ Digit increment/decrement
4. ✅ Code entry and shifting
5. ✅ Incorrect password rejection
6. ✅ Correct password acceptance
7. ✅ Programming mode entry/exit
8. ✅ New password storage
9. ✅ Reset to default password
10. ✅ Edge case handling

### Running Simulation
```tcl
# ModelSim commands
vlib work
vlog DigitalLockSystem_COMMENTED.v
vlog ModeController_COMMENTED.v
vlog CodeEntry_REFACTORED.v
vlog CodeControl_REFACTORED.v
vlog tests/DigitalLockSystem_tb.v
vsim DigitalLockSystem_tb
run -all
```

---

## Synthesis

### Compilation
1. Open Quartus II V13.0-SP1
2. Create new project targeting Cyclone II EP2C35F672C6
3. Add all .v files to project
4. Set `DigitalLockSystem` as top-level entity
5. Compile design

### Pin Assignment
Assign pins according to DE2 board manual:
- Clock: PIN_N2 (CLOCK_50)
- Switches: SW[17:16]
- Keys: KEY[3:0]
- LEDs: LEDR[0], LEDG[0]
- 7-Segment: HEX3-HEX0

### Resource Usage (Expected)
- Logic Elements: ~300
- Registers: ~50
- Maximum Frequency: >100 MHz

---

## Assignment Requirements Met

### Assignment 1 (15%)
✅ Block diagrams with interconnections  
✅ ASM charts for all state machines  
✅ Verilog code for number entry modules  
✅ Verilog code for counters  
✅ Simulation of coded modules  

### Assignment 2 (25%)
✅ Complete system implementation  
✅ Full module documentation  
✅ Commented Verilog code  
✅ System-level simulation  
✅ Schematic generation  
⚠️ DE2 board testing (limited by lab access)  

---

## Known Issues / Limitations

1. **Hardware Testing**: Limited DE2 board access prevented full experimental validation
2. **7-Segment Decoder**: Not included (display shows raw BCD values)
3. **Button Debouncing**: Relies on edge detection; additional debouncing may be needed for physical hardware

---

## Future Enhancements

- [ ] Add 7-segment decoder for proper digit display
- [ ] Implement timer-based auto-lock
- [ ] Add wrong password attempt counter with lockout
- [ ] Support for longer passwords (6-8 digits)
- [ ] Multiple user passwords
- [ ] EEPROM integration for non-volatile storage

---

## Technical Specifications

| Parameter | Value |
|-----------|-------|
| Clock Frequency | 50 MHz |
| Reset Type | Asynchronous active-low |
| Button Inputs | Active-low (DE2 standard) |
| Internal Logic | Active-high |
| Password Length | 4 digits (16 bits) |
| Digit Range | 0-9 decimal |
| State Machine Type | Moore FSM |
| Design Style | Fully synchronous |

---

## Author

**Student ID:** [Last 4 digits: 2019]  
**Module:** ELEC473 - Digital Systems Design  
**Submission:** Assignment 2 - February 2026  

---

## References

1. Altera DE2 Development and Education Board User Manual
2. Quartus II Handbook - Design Recommendations
3. IEEE Standard Verilog Hardware Description Language (IEEE 1364-2005)
4. ELEC473 Course Materials - University of Liverpool

---

## License

This project is submitted as coursework for ELEC473. Code is provided for educational purposes and assessment only.

**Academic Integrity Notice:** This work represents original design and implementation for course assessment. Any use or reproduction must comply with university academic integrity policies.

---

*Last Updated: February 2026*