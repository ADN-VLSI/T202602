module seqdetect_1011(input in,clk,rst, output reg op);
  reg [1:0] current_state;
  reg [1:0] next_state;
  
  parameter A=2'b00;
  parameter B=2'b01;
  parameter C=2'b10;
  parameter D=2'b11;
  
  always@(posedge clk)
    begin 
      if(rst==0) 
        current_state<=A;
      
      else begin
        current_state<=next_state;
       
      end
    end
  always@(*) begin
    op=0;
    
    case(current_state) 
     
      A : begin
        if(in) begin
          next_state=B;
           
        end
        else  begin
          next_state=A;
       
        end
      end
      B : begin
        if(in) begin
          next_state=B;
          
        end
        else  begin
          next_state=C;
        
        end
      end
      C : begin
        if(in) begin
          next_state=D;
          
        end
        else  begin
          next_state=A;
         
        end
      end
      D : begin
        if(in) begin
          next_state=A;
          op=1;
         
        end
        else  begin
          next_state=C;
        
        end
      end
      default: begin
        next_state = A;
        op = 0;
      end
        
    endcase
  end
      
endmodule
    