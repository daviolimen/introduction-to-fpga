module memory #(
    parameter MEM_WIDTH = 16,
    parameter MEM_DEPTH = 256,
    parameter INIT_FILE = ""
) (
    input clk,
    input w_en,
    input r_en,
    input [ADDR_WIDTH - 1:0] w_addr,
    input [ADDR_WIDTH - 1:0] r_addr,
    input [MEM_WIDTH - 1:0] w_data,

    output reg [MEM_WIDTH - 1:0] r_data
);

    localparam ADDR_WIDTH = $clog2(MEM_DEPTH);
    
    reg [MEM_WIDTH - 1:0] mem [0:MEM_DEPTH - 1];

    always @ (posedge clk) begin
        if (w_en) begin
            mem[w_addr] <= w_data;
        end

        if (r_en) begin
            r_data <= mem[r_addr];
        end
    end

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end
endmodule