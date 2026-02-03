module DirectionLogic(up, down, dir, valid);
    input up;
    input down;
    output dir;
    output valid;
    
    assign valid = up ^ down;  // XOR - only valid if exactly one pressed
    assign dir = up;           // 1=up, 0=down
endmodule