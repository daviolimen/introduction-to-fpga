module button_counter_pro (
    input clk,
    input rst_btn,
    input inc_btn,

    output reg [3:0] led
);

    localparam STATE_IDLE = 2'd0;
    localparam STATE_INC = 2'd1;
    localparam STATE_WAIT = 2'd2;

    localparam MAX_WAIT_COUNT = 32'd5000000;

    wire rst;
    assign rst = ~rst_btn;
    wire inc;
    assign inc = ~inc_btn;

    reg [31:0] wait_count;
    reg [1:0] state;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
            led <= 4'b0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    wait_count <= MAX_WAIT_COUNT;
                    if (inc == 1'b1) begin
                        state <= STATE_INC;
                    end
                end

                STATE_INC: begin
                    led <= led + 1;
                    state <= STATE_WAIT;
                end

                STATE_WAIT: begin
                    if (wait_count == 32'b0) begin
                        state <= STATE_IDLE;
                    end else begin
                        wait_count <= wait_count - 1;
                    end
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end

endmodule