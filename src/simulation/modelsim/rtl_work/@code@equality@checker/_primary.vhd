library verilog;
use verilog.vl_types.all;
entity CodeEqualityChecker is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        match           : out    vl_logic
    );
end CodeEqualityChecker;
