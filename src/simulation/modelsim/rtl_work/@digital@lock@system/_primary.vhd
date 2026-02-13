library verilog;
use verilog.vl_types.all;
entity DigitalLockSystem is
    port(
        swx_n           : in     vl_logic;
        swm             : in     vl_logic;
        keya            : in     vl_logic;
        keyb            : in     vl_logic;
        keyc            : in     vl_logic;
        keyd            : in     vl_logic;
        clk             : in     vl_logic;
        rledx           : out    vl_logic;
        gledx           : out    vl_logic;
        hexx_y          : out    vl_logic_vector(15 downto 0)
    );
end DigitalLockSystem;
