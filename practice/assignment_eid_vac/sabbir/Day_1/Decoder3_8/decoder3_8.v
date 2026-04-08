module decoder3_8(input [2:0]i,output reg [7:0]y);
      always@(*) begin
        if(i == 3'b000)
            y=8'b0000001;
        else if(i == 8'b001)
            y=8'b00000010;
        else if(i == 8'b010)
            y=8'b00000100;
        else if(i == 8'b011)
            y=8'b00001000;
        else if(i == 8'b100)
            y=8'b00010000;
        else if(i == 8'b101)
            y=8'b00100000;
        else if(i == 8'b110)
            y=8'b01000000;
        else if(i == 8'b111)
            y=8'b10000000;
        end
                                 
endmodule