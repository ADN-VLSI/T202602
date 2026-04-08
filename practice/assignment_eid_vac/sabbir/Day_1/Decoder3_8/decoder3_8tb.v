module decoder3_8tb;
  reg [2:0]i;
  wire [7:0]y;
    
    decoder3_8 uut(i,y);
    

    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
        i=8'b000;
        #1;
        i=8'b001;
        #1;
         i=8'b010;
        #1;
        i=8'b011;
        #1;
         i=8'b100;
        #1;
        i=8'b101;
        #1;
         i=8'b110;
        #1;
        i=8'b111;
       #1;
       $finish;
       end
endmodule