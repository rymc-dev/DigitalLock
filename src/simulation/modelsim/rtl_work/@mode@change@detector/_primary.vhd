library verilog;
use verilog.vl_types.all;
entity ModeChangeDetector is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        current_mode    : in     vl_logic_vector(1 downto 0);
        is_mode_change  : out    vl_logic
    );
end ModeChangeDetector;
