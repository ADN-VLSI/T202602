module fa(input a,b,cin,output sum,cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (cin & a);
endmodule


module adder_4bit(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout
);

  wire [2:0] w; // intermediate carries

  fa fa1(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(w[0]));
  fa fa2(.a(a[1]), .b(b[1]), .cin(w[0]), .sum(sum[1]), .cout(w[1]));
  fa fa3(.a(a[2]), .b(b[2]), .cin(w[1]), .sum(sum[2]), .cout(w[2]));
  fa fa4(.a(a[3]), .b(b[3]), .cin(w[2]), .sum(sum[3]), .cout(cout));

endmodule
