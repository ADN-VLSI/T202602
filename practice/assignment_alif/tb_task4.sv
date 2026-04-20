module tb;

  student s1, s2;

  initial begin
    // object creation with constructor
    s1 = new("Tuhin", 1489, 78.5);
    s2 = new("Karim", 1501, 85.0);

    // display information
    $display("\n--- Student Details ---");
    s1.show_info();
    s2.show_info();
  end

endmodule