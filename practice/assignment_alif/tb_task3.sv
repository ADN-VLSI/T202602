module tb;

  packet pkt;

  initial begin
    // constructor diye value pass
    pkt = new(8'h1F, 8'hAA, 1'b0);

    pkt.display();
  end

endmodule