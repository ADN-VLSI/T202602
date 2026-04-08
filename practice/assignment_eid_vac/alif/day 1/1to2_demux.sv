///3) 1:2 DEMUX 
///RTL 
module demux1to2( 
input  logic din, 
input  logic sel, 
output logic y0, 
output logic y1 
); 
always_comb begin 
y0 = 0; 
y1 = 0; 
if(sel==0) y0 = din; 
else    
   y1 = din; 
end 
endmodule
