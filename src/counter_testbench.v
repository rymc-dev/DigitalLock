`timescale 10ns/100ps

module counter_testbench;

reg clk_sig;
wire [3:0] count_sig;
wire [3:0] count_sig_2;

initial begin
    clk_sig = 0;
end

always #10 clk_sig = !clk_sig;

counter counter_inst (
    .clk   (clk_sig),
    .count (count_sig)
);
counter counter_inst_2 (
    .clk   (clk_sig),
    .count (count_sig_2)
);

endmodule
