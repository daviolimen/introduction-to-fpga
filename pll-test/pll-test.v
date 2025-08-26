module pll_test (
    input ref_clk,
    output clk
);

    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .PLLOUT_SELECT("GENCLK"),
        .DIVR(4'b000),
        .DIVF(7'b1001111),
        .DIVQ(3'b011),
        .FILTER_RANGE(3'b001)
    ) pll (
        .REFERENCECLK(ref_clk),
        .PLLOUTCORE(clk),
        .LOCK(),
        .RESETB(1'b1),
        .BYPASS(1'b0)
    );

endmodule