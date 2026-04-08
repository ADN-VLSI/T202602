module encoder8_3tb;
    reg [7:0]i;
    wire [2:0]y;
    
    encoder8_3 uut(i,y);
    
//    initial begin
//        {i}=0;
//        end
    initial begin
        i=8'b00000001;
        #1;
        i=8'b00000010;
        #1;
         i=8'b00000100;
        #1;
        i=8'b00001000;
        #1;
         i=8'b00010000;
        #1;
        i=8'b00100000;
        #1;
         i=8'b01000000;
        #1;
        i=8'b10000000;
       #1;
       $finish;
       end
endmodule
