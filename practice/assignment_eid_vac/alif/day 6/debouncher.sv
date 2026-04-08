///6.Debouncer (for button press) 
module debouncer( 
input clk, btn, 
output reg clean 
); 
    reg [3:0] shift; 
    always @(posedge clk) begin 
        shift <= {shift[2:0], btn}; 
        clean <= (shift == 4'b1111); // stable high 
    end 
endmodule