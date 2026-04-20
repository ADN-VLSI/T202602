class student;

  // properties
  string name;
  int id;
  real marks;

  // constructor (proper use)
  function new(string n, int i, real m);
    name  = n;
    id    = i;
    marks = m;
  endfunction

  // display method
  function void show_info();
    $display("Student Name: %s | ID: %0d | Marks: %0.2f", name, id, marks);
  endfunction

endclass