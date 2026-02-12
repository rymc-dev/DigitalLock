library verilog;
use verilog.vl_types.all;
entity CodeShiftRegister is
    port(
        digit           : in     vl_logic_vector(3 downto 0);
        rst_n           : in     vl_logic;
        shift           : in     vl_logic;
        clk             : in     vl_logic;
        code            : out    vl_logic_vector(15 downto 0)
    );
end CodeShiftRegister;
