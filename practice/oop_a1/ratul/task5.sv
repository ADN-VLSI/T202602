class rectangle;
  int length;
  int width;

  function int area();
    return length * width;
  endfunction

  function int perimeter();
    return 2 * (length + width);
  endfunction
endclass

module test_rectangle;
  rectangle r;

  initial begin
    r = new();
    r.length = 10;
    r.width = 5;
    $display("Area: %0d, Perimeter: %0d", r.area(), r.perimeter());
  end
endmodule