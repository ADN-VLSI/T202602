//overlap mealy fsm
module seqdetect_1101(input in,clk,rst, output reg op);
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
      
      else 
        current_state<=next_state;
    end
  always@(*) begin
    op=0;
    
    case(current_state) 
     
      A : begin
        if(in)
          next_state=B;
        else  
          next_state=A;
      end
      B : begin
        if(in) 
          next_state=C;
        else 
          next_state=A;
      end
      C : begin
        if(in) 
          next_state=C;
        else  
          next_state=D;
      end
      D : begin
        if(in) begin 
          next_state=B;
          op=1;
        end
        else  
          next_state=A;
      end
 

    endcase
  end
      