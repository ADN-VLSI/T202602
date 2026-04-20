module tb;

  packet pkt;

  initial begin
    pkt = new();

    pkt.addr  = 8'hAA;
    pkt.data  = 8'h55;
    pkt.write = 1'b1;

    pkt.display();
  end

endmodule