library verilog;
use verilog.vl_types.all;
entity CodeControl is
    port(
        current_mode    : in     vl_logic_vector(1 downto 0);
        current_code    : in     vl_logic_vector(15 downto 0);
        keya            : in     vl_logic;
        rst_n           : in     vl_logic;
        clk             : in     vl_logic;
        unlock          : out    vl_logic
    );
end CodeControl;
