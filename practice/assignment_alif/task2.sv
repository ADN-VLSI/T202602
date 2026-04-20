class packet;

  bit [7:0] addr;
  bit [7:0] data;
  bit write;

  function void display();
    $display("Addr=%0h Data=%0h Write=%0b", addr, data, write);
  endfunction

endclass