///6) Clock Divider (/2 and /4) 
module clock_divider ( 
    input  logic clk, 
    input  logic rst, 
    output logic clk_div2, 
    output logic clk_div4 
); 
    logic [1:0] div_cnt; 
 
    always_ff @(posedge clk) begin 
        if (rst) begin 
            clk_div2 <= 0; 
            div_cnt  <= 0; 
        end else begin 
            clk_div2 <= ~clk_div2;               // divide by 2 
            div_cnt  <= div_cnt + 1; 
        end 
    end 
 
    assign clk_div4 = div_cnt[1];                // divide by 4 
endmodule 