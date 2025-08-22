module and_gate (
    input [2:0] pmod,

    output [2:0] led
);

    wire A, B, Cin;
    assign A = ~pmod[0];
    assign B = ~pmod[1];
    assign Cin = ~pmod[2];

    assign led[0] = A ^ B ^ Cin;
    assign led[1] = ((A ^ B) & Cin) | (A & B);

endmodule