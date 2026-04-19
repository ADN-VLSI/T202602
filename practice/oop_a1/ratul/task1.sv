class packet;
  bit [7:0] addr;
  bit [7:0] data;
  bit write;

  function void display();
    $display("addr = %0d, data = %0d, write = %0d", addr, data, write);
  endfunction
endclass