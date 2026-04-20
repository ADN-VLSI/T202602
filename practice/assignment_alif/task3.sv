class packet;

  // properties
  bit [7:0] addr;
  bit [7:0] data;
  bit write;

  // constructor
  function new(bit [7:0] a, bit [7:0] d, bit w);
    this.addr  = a;
    this.data  = d;
    this.write = w;
  endfunction

  // display method
  function void display();
    $display("Addr=%0h, Data=%0h, Write=%0b", addr, data, write);
  endfunction

endclass