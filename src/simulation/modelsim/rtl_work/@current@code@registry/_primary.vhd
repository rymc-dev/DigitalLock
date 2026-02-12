library verilog;
use verilog.vl_types.all;
entity CurrentCodeRegistry is
    port(
        code            : in     vl_logic_vector(15 downto 0);
        shift           : in     vl_logic;
        rst_n           : in     vl_logic;
        clk             : in     vl_logic;
        stored_code     : out    vl_logic_vector(15 downto 0)
    );
end CurrentCodeRegistry;
