module sync_2ff #(parameter WIDTH = 8)(
    input wire clk,                // Destination clock domain
    input wire rst_n,              // Active-low reset
    input wire [WIDTH-1:0] async_in, // Asynchronous input signal
    output wire [WIDTH-1:0] sync_out // Synchronized output
);

    reg [WIDTH-1:0] sync_ff1, sync_ff2; // 2 FF registers for synchronization

    always @(posedge clk ) begin
        if (!rst_n) begin
            sync_ff1 <= {WIDTH{1'b0}};
            sync_ff2 <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= async_in;   // First stage
            sync_ff2 <= sync_ff1;   // Second stage
        end
    end

    assign sync_out = sync_ff2; // Synchronized output

endmodule