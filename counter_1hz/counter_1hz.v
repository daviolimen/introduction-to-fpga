module counter_1hz (
    input clk,
    input [1:0] pmod,
    output reg [3:0] led
);

    wire rst;
    assign rst = ~pmod[0];

    reg [31:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            led <= 4'b0;
            cnt <= 32'b0;
        end else if (cnt == 32'd12000000) begin
            cnt <= 32'b1;
            led <= led + 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
endmodule