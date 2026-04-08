module bothedge_detector(input signal,clk, output reg out);
  reg previous;
  always@(posedge clk) begin
    out <= previous ^ signal;
    previous <= signal;
  end
endmodule