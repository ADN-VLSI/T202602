module dual_flop_sync (
    input  logic clk,        // Destination clock domain
    input  logic rst_n,      // Active-low reset
    input  logic async_in,   // Asynchronous input signal
    output logic sync_out    // Synchronized output
);

    logic sync_ff1, sync_ff2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;
        end else begin
            sync_ff1 <= async_in;   // First stage
            sync_ff2 <= sync_ff1;   // Second stage
        end
    end

    assign sync_out = sync_ff2;

endmodule