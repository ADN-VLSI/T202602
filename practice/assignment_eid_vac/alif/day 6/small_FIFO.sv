///3. Small FIFO (4×8-bit) 
module small_fifo( 
    input clk, 
    input rst, 
    input wr_en, 
    input rd_en, 
    input [7:0] din, 
    output reg [7:0] dout, 
    output full, empty 
); 
    reg [7:0] fifo_mem [0:3]; 
    reg [1:0] wr_ptr, rd_ptr; 
    reg [2:0] count; 
 
    assign full = (count==4); 
    assign empty = (count==0); 
 
    always @(posedge clk or posedge rst) begin 
        if(rst) begin 
            wr_ptr <= 0; rd_ptr <= 0; count <= 0; 
            dout <= 0; 
        end else begin 
            if(wr_en && !full) begin 
                fifo_mem[wr_ptr] <= din; 
                wr_ptr <= wr_ptr + 1; 
                count <= count + 1; 
            end 
            if(rd_en && !empty) begin 
                dout <= fifo_mem[rd_ptr]; 
                rd_ptr <= rd_ptr + 1; 
                count <= count - 1; 
            end 
        end 
    end 
endmodule 