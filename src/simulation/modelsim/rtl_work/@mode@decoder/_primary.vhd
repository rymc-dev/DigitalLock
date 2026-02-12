library verilog;
use verilog.vl_types.all;
entity ModeDecoder is
    port(
        mode            : in     vl_logic_vector(1 downto 0);
        enable_validate : out    vl_logic;
        enable_program  : out    vl_logic
    );
end ModeDecoder;
