class rectangle;

  // properties
  real length;
  real width;

  // constructor
  function new(real l, real w);
    length = l;
    width  = w;
  endfunction

  // function to calculate area
  function real area();
    return length * width;
  endfunction

  // function to calculate perimeter
  function real perimeter();
    return 2 * (length + width);
  endfunction

endclass