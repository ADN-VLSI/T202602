module demux2_1 (input s,i, output reg [1:0]y);
  always@(*)
    begin
      case(s)
        
        0:begin
          y[0]=i;
          y[1]=0;
        end
         
        1:begin
          y[0]=0;
          y[1]=i;
        end
         default : y = 0 ;
          
       endcase  
    end
endmodule