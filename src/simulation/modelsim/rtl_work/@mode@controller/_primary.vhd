library verilog;
use verilog.vl_types.all;
entity ModeController is
    port(
        unlock          : in     vl_logic;
        swx_n           : in     vl_logic;
        swm             : in     vl_logic;
        keya            : in     vl_logic;
        clk             : in     vl_logic;
        rledx           : out    vl_logic;
        gledx           : out    vl_logic;
        mode            : out    vl_logic_vector(1 downto 0)
    );
end ModeController;
