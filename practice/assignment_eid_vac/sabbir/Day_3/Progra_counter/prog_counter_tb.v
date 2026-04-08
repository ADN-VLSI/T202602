module prog_counter_tb;

    reg clk;
    reg reset;
    reg load;
    reg M;
    reg [2:0] preset;
    wire [2:0] Q;
    wire termi_count;

    prog_counter uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .M(M),
        .preset(preset),
        .Q(Q),
      .termi_count(termi_count)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    //   $dumpfile("pro_counter.vcd");
    //   $dumpvars(1);

        // init
        reset  = 0;
        load   = 0;
        M      = 1;       // up
        preset = 3'b000;

        // synchronous reset
      @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;

        // load 101
        preset = 3'b101;
        load   = 1;
        @(posedge clk);
        load   = 0;

        // up count using given equations
        M = 1;
      repeat (7) @(posedge clk);

        // load 011
        preset = 3'b011;
        load   = 1;
        @(posedge clk);
        load   = 0;

        // down count using given equations
        M = 0;
      repeat (7) @(posedge clk);

        // check terminal count in up mode
        preset = 3'b110;
        load   = 1;
        @(posedge clk);
        load   = 0;
        
      repeat (3) @(posedge clk);

        $finish;
    end
  
  

endmodule