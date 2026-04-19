// Task 5 
class rectangle;
  real length;
  real width;

  // Constructor
  function new(real l = 0, real w = 0);
    length = l;
    width = w;
  endfunction

  // Method to calculate area 
  function real area();
    return length * width;
  endfunction

  // Method to calculate perimeter
  function real perimeter();
    return 2 * (length + width);
  endfunction

  // Display method
  function void display();
    $display("Rectangle:");
    $display("  Length: %0.2f", length);
    $display("  Width: %0.2f", width);
    $display("  Area: %0.2f", area());
    $display("  Perimeter: %0.2f", perimeter());
  endfunction
endclass

// Testbench module to demonstrate rectangle class
module task5_rectangle_class_tb;
  initial begin
    $display("Task 5: Rectangle Class with Return Methods \n");

    // Create rectangle objects
    rectangle rect1 = new(5.5, 3.2);
    rect1.display();
    $display("");

    rectangle rect2 = new(10.0, 8.0);
    rect2.display();
    $display("");

    rectangle rect3 = new(7.25, 4.5);
    rect3.display();

    $display("\n");
  end
endmodule