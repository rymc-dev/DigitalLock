library verilog;
use verilog.vl_types.all;
entity CodeEntry is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        current_mode    : in     vl_logic_vector(1 downto 0);
        keyb_s          : in     vl_logic;
        keyc_s          : in     vl_logic;
        keyd_s          : in     vl_logic;
        code            : out    vl_logic_vector(15 downto 0)
    );
end CodeEntry;
