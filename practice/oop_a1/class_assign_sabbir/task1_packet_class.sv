// Task 1: Create a simple class
class packet;
  bit [7:0] addr;
  bit [7:0] data;
  bit write;

  // Display function to print values
  function void display();
    $display("Packet: addr=0x%h, data=0x%h, write=%b", addr, data, write);
  endfunction
endclass