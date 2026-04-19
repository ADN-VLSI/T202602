class packet;
  bit [7:0] addr;
  bit [7:0] data;
  bit write;

  function new(bit [7:0] a=0, bit [7:0] d=0, bit w=0);
    addr = a;
    data = d;
    write = w;
  endfunction

  function void display();
    $display("addr = %0d, data = %0d, write = %0d", addr, data, write);
  endfunction
endclass

module test_packet_new;
  packet p;

  initial begin
    p = new(8'h10, 8'h20, 1);
    p.display();
  end
endmodule