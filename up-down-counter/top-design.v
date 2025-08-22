module top_design (
    input clk,
    input rst_btn,
    input go_btn,
    
    output reg [3:0] led
);

    localparam STATE_IDLE = 2'd0;
    localparam STATE_UP = 2'd1;
    localparam STATE_DOWN = 2'd2;

    wire rst;
    wire go;
    assign rst = ~rst_btn;
    assign go = ~go_btn;

    wire div_clk;
    clock_divider divider (clk, rst, div_clk);
    defparam divider.COUNT_WIDTH = 32;
    defparam divider.MAX_COUNT = 1500000 - 1;

    reg [1:0] state;

    always @ (posedge div_clk or posedge rst) begin
        if (rst == 1'b1) begin
            led <= 4'b0;
            state <= STATE_IDLE;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (go == 1'b1) begin
                        state <= STATE_UP;
                    end
                end

                STATE_UP: begin
                    if (led == 4'hf) begin
                        state <= STATE_DOWN;
                    end else begin
                        led <= led + 1;
                    end
                end

                STATE_DOWN: begin
                    if (led == 4'b0) begin
                        state <= STATE_UP;
                    end else begin
                        led <= led - 1;
                    end
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule