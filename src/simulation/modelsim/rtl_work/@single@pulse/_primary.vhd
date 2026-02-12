library verilog;
use verilog.vl_types.all;
entity SinglePulse is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        trigger         : in     vl_logic;
        pulse           : out    vl_logic
    );
end SinglePulse;
