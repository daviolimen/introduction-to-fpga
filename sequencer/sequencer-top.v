module sequencer_top #(
    parameter DEBOUNCE_COUNTS = 480000 - 1,
    parameter STEP_COUNTS = 6000000 - 1,
    parameter NUM_STEPS = 8
) (
    input clk,
    input rst_btn,
    input set_btn,
    input ptn_0_btn,
    input ptn_1_btn,

    output reg [1:0] led,
    output [2:0] unused_led
);

    wire rst;
    wire set;
    wire set_d;
    wire [1:0] ptn;
    wire div_clk;
    wire [1:0] r_data;

    reg w_en = 0;
    reg r_en = 1;
    reg [2:0] w_addr = 0;
    reg [2:0] r_addr;
    reg [1:0] w_data;
    reg [2:0] step_counter;
    reg [2:0] mem_ptr = 0;

    assign unused_led = 3'b000;

    assign rst = ~rst_btn;
    assign set = ~set_btn;
    assign ptn[0] = ~ptn_0_btn;
    assign ptn[1] = ~ptn_1_btn;

    clock_divider #(.COUNT_WIDTH(24), .MAX_COUNT(STEP_COUNTS)) div (clk, rst, div_clk);

    debouncer #(.COUNT_WIDTH(24), .MAX_CLK_COUNT(DEBOUNCE_COUNTS)) set_debouncer (clk, rst, set, set_d);

    memory #(.MEM_WIDTH(2), .MEM_DEPTH(NUM_STEPS), .INIT_FILE("mem_init.txt")) mem (clk, w_en, r_en, w_addr, r_addr, w_data, r_data);

    always @ (posedge div_clk or posedge rst) begin
        if (rst == 1'b1) begin
            led <= 0;
            r_addr <= 0;
            step_counter <= 0;
        end else begin
            r_addr <= step_counter;
            step_counter <= step_counter + 1;
            led <= r_data;
        end
    end

    always @ (posedge set_d) begin
        w_data <= ptn;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            mem_ptr <= 0;
            w_en <= 1'b0;
        end else if (set_d == 1'b1) begin
            w_addr <= mem_ptr;
            w_en <= 1'b1;
            mem_ptr <= mem_ptr + 1;
        end else begin
            w_en <= 1'b0;
        end
    end
endmodule