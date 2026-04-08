module comparator_4bit (
    input logic [3:0] a, b,
    output logic eq, gt, lt
);
    assign eq = (a == b);
    assign gt = (a > b);
    assign lt = (a < b);
endmodule