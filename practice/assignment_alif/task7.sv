class transaction;

  // random variables
  rand bit [7:0] addr;
  rand bit [7:0] data;

  // constraint
  constraint addr_range {
    addr >= 10;
    addr <= 20;
  }

  // display method
  function void display();
    $display("Addr = %0d | Data = %0h", addr, data);
  endfunction

endclass