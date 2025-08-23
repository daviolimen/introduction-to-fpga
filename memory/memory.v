module memory #(
    parameter INIT_FILE = ""
) (
    input clk,
    input w_en,
    input r_en,
    input [3:0] w_addr,
    input [3:0] r_addr,
    input [7:0] w_data,

    output reg [7:0] r_data
);

    reg [7:0] mem [0:15];

    always @ (posedge clk) begin
        if (w_en == 1'b1) begin
            mem[w_addr] <= w_data;
        end

        if (r_en == 1'b1) begin
            r_data <= mem[r_addr];
        end
    end

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end
endmodule