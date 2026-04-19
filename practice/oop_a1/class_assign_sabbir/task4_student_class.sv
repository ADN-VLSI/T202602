// Task 4
class student;
  string name;
  int id;
  int marks;

  // Constructor
  function new(string n = "", int i = 0, int m = 0);
    name = n;
    id = i;
    marks = m;
  endfunction

  // Method to print details
  function void display_details();
    $display("Student Details:");
    $display("  Name: %s", name);
    $display("  ID: %d", id);
    $display("  Marks: %d", marks);
  endfunction
endclass

// Testbench module to demonstrate student class
module task4_student_class_tb;
  initial begin
    $display("Task 4: Student Class Demonstration \n");

    // Create student objects
    student std1 = new("Sabbir", 101, 95);
    std1.display_details();
    $display("");

    student std2 = new("Rony", 102, 87);
    std2.display_details();
    $display("");

    student std3 = new("Joy", 103, 92);
    std3.display_details();

    $display("\n");
  end
endmodule