module top_design (
    input clk,
    input rst_btn,

    output [1:0] led
);

    wire rst;
    assign rst = ~rst_btn;

    clock_divider #(31, 1500000 - 1) div_1 (clk, rst, led[0]);

    clock_divider div_2(clk, rst, led[1]);

endmodule