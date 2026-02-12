# Code Control

CodeControl 
This module is the key module for code control, we get input from code 
entry and utilize this internally based on the current mode we are in and 
we expect to happen.

Based on the diagram:
- ModeDecoder generates enable_validate and enable_program based on current mode
- CurrentCodeRegistry stores the programmed password (default 4'd2019)
- CodeEqualityChecker compares current_code with stored password
- UnlockLogic combines enable_validate, match signal, and keya trigger to unlock