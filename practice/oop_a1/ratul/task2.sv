module test_packet;
  packet p;

  initial begin
    p = new();
    p.addr = 8'h10;
    p.data = 8'h20;
    p.write = 1;
    p.display();
  end
endmodule