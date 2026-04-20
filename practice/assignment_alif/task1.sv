class packet;

  // properties (variables)
  bit [7:0] addr;
  bit [7:0] data;
  bit write;

  // display function
  function void display();
    $display("Address = %0h, Data = %0h, Write = %0b", addr, data, write);
  endfunction

endclass