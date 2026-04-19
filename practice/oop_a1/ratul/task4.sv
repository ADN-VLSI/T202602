class student;
  string name;
  int id;
  int marks;

  function void display();
    $display("Name: %s, ID: %0d, Marks: %0d", name, id, marks);
  endfunction
endclass

module test_student;
  student s;

  initial begin
    s = new();
    s.name = "John";
    s.id = 123;
    s.marks = 95;
    s.display();
  end
endmodule