class transaction;

  // random variables
  rand bit [7:0] addr;
  rand bit [7:0] data;

  // display method
  function void display();
    $display("Addr = %0h | Data = %0h", addr, data);
  endfunction

endclass

