module bin2gray #(parameter n=4)
  (input [n-1:0] bin, output[n-1:0] gray_op);
  assign gray_op= bin^(bin>>1);
  
endmodule