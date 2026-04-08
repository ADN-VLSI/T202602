//5. Pulse Generator (1-clock pulse every 4 cycles) 
module pulse_gen( 
input clk, rst, 
output reg pulse 
); 
reg [1:0] cnt; 
always @(posedge clk or posedge rst) begin 
if(rst) begin cnt<=0; pulse<=0; end 
else begin 
cnt <= cnt + 1; 
pulse <= (cnt==3); 
end 
end 
endmodule