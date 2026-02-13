# ModeController State Transitions

The ModeController FSM has **5 unique transitions**

## Coverage Matrix

| Path # | Transition | Trigger | Tested | Line # | Result |
|--------|-----------|---------|--------|--------|--------|
| 1 | LOCKED → UNLOCKED | unlock | ✓ | ~180 | PASS |
| 2 | UNLOCKED → LOCKED | keya↑ | ✓ | ~340 | PASS |
| 3 | UNLOCKED → UNLOCKED_PROG | swm↑ | ✓ | ~230 | PASS |
| 4 | UNLOCKED_PROG → UNLOCKED | swm↓ | ✓ | ~295 | PASS |
| 5 | UNLOCKED_PROG → LOCKED | keya↑ | ✓ | ~250 & ~320 | PASS |
