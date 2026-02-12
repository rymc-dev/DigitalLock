library verilog;
use verilog.vl_types.all;
entity UnlockLogic is
    port(
        enable_validate : in     vl_logic;
        match           : in     vl_logic;
        trigger_validate: in     vl_logic;
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        unlock          : out    vl_logic
    );
end UnlockLogic;
