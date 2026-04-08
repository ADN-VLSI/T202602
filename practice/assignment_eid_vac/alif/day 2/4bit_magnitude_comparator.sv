///3) 4-bit Magnitude Comparator 
module magnitude_comparator4( 
input logic [3:0] a,b, 
output logic gt,lt,eq 
); 
always_comb begin 
gt=(a>b); lt=(a<b); eq=(a==b); 
end 
endmodule 