module tb;

  rectangle r1;
  real a, p;

  initial begin
    // object creation
    r1 = new(10.0, 5.0);

    // function call
    a = r1.area();
    p = r1.perimeter();

    // display result
    $display("Area = %0.2f", a);
    $display("Perimeter = %0.2f", p);
  end

endmodule