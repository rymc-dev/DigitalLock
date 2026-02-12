library verilog;
use verilog.vl_types.all;
entity UpDownCounterWrap is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        ud              : in     vl_logic;
        trigger         : in     vl_logic;
        count           : out    vl_logic_vector(3 downto 0)
    );
end UpDownCounterWrap;
