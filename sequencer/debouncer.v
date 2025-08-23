module debouncer #(
    parameter COUNT_WIDTH = 20,
    parameter [COUNT_WIDTH:0] MAX_CLK_COUNT = 480000 - 1
) (
    input clk,
    input rst,
    input in,
    output reg out
);

    localparam STATE_HIGH = 2'd0;
    localparam STATE_LOW = 2'd1;
    localparam STATE_WAIT = 2'd2;
    localparam STATE_PRESSED = 2'd3;

    reg [1:0] state;
    reg [COUNT_WIDTH:0] clk_count;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1) begin
            state <= STATE_HIGH;
            out <= 0;
        end else begin
            case (state)
                STATE_HIGH: begin
                    out <= 0;
                    if (in == 0) state <= STATE_LOW;
                end

                STATE_LOW: begin
                    if (in == 1) state <= STATE_WAIT;
                end

                STATE_WAIT: begin
                    if (clk_count == MAX_CLK_COUNT) begin
                        if (in == 1) state <= STATE_PRESSED;
                        else state <= STATE_HIGH;
                    end
                end

                STATE_PRESSED: begin
                    out <= 1;
                    state <= STATE_HIGH;
                end

                default: state <= STATE_HIGH;
            endcase
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1) begin
            clk_count <= 0;
        end else begin
            if (state == STATE_WAIT) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
            end
        end
    end
endmodule