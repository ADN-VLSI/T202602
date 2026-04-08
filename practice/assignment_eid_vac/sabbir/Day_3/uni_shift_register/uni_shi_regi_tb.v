// Code your design here
module uni_shi_regi_tb;

  reg clk, rst, sr_in, sl_in;
  reg [1:0] sel;
  reg [3:0] p_in;
  wire [3:0] out;

  uni_shi_regi dut(clk, rst, sr_in, sl_in, sel, p_in, out);

  // Clock generation
  initial begin
    clk = 1;
    forever #10 clk = ~clk;
  end

  initial begin
    // $dumpfile("uni.vcd");
    // $dumpvars(1);

    // Initial values
    rst   = 0;
    sr_in = 0;
    //sl_in = 0;
    sel   = 2'b00;
    p_in  = 4'b0000;

    // Reset active
    #10;
    rst = 1;

    // HOLD
    sel = 2'b00;
    #10;

    // SHIFT RIGHT
    sel = 2'b01; 
    sr_in = 1;
    #80;

    // SHIFT LEFT
    sel = 2'b10; 
    sl_in = 0;
    #80;

    // PARALLEL LOAD
    sel = 2'b11; p_in = 4'b1010;
    #20;

    $finish;
  end

endmodule