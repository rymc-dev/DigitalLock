library verilog;
use verilog.vl_types.all;
entity DirectionLogic is
    port(
        up              : in     vl_logic;
        down            : in     vl_logic;
        dir             : out    vl_logic;
        valid           : out    vl_logic
    );
end DirectionLogic;
