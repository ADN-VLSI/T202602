///2) Programmable Counter 
module programmable_counter ( 
    input  logic       clk, 
    input  logic       rst, 
    input  logic       up_down,      // 1=up, 0=down 
    input  logic       load, 
    input  logic [3:0] load_value, 
    output logic [3:0] count, 
    output logic       tc            // terminal count flag 
); 
    always_ff @(posedge clk) begin 
        if (rst) 
            count <= 4'd0;                    // synchronous reset 
        else if (load) 
            count <= load_value;              // load start value 
        else if (up_down) 
            count <= count + 1;               // count up 
        else 
            count <= count - 1;               // count down 
    end 
 
    assign tc = up_down ? (count == 4'hF) : (count == 4'h0); // terminal flag 
endmodule 