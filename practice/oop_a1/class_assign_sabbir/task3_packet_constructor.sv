// Task 3
class packet;
  bit [7:0] addr;
  bit [7:0] data;
  bit write;

  // Constructor to initialize 
  function new(bit [7:0] a = 0, bit [7:0] d = 0, bit w = 0);
    addr = a;
    data = d;
    write = w;
  endfunction

  // Display function to print values
  function void display();
    $display("Packet: addr=0x%h, data=0x%h, write=%b", addr, data, write);
  endfunction
endclass

// Testbench module 
module task3_packet_constructor_tb;
  initial begin
    $display("Task 3:Packet Constructor Demonstration \n");

    // Create object with default constructor values
    packet pkt1 = new();
    pkt1.display();

    // Create object 
    packet pkt2 = new(8'hFF, 8'h55, 1'b1);
    pkt2.display();

    // Create another object
    packet pkt3 = new(8'h12, 8'h34, 1'b0);
    pkt3.display();

    $display("\n");
  end
endmodule