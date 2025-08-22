`timescale 1ns / 10ps

module clock_divider_tb();

    wire out;

    reg clk = 0;
    reg rst = 0;

    localparam DURATION = 10000;

    always begin
        #41.67
        clk = ~clk;
    end

    clock_divider #(.COUNT_WIDTH(4), .MAX_COUNT(5)) uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    initial begin
        #10;
        rst = 1'b1;
        #1
        rst = 1'b0;
    end

    initial begin
        $dumpfile("_build/default/clk-div_tb.vcd");
        $dumpvars(0, clock_divider_tb);

        #(DURATION)

        $display("Finished!");
        $finish;
    end
endmodule