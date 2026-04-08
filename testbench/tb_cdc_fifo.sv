module tb_cdc_fifo;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    // DUT signals
    logic wr_clk, rd_clk;
    logic wr_rst_n, rd_rst_n;

    logic wr_en, rd_en;
    logic [DATA_WIDTH-1:0] wr_data;
    logic [DATA_WIDTH-1:0] rd_data;

    logic full, empty;

    // Instantiate DUT
    cdc_fifo #(DATA_WIDTH, ADDR_WIDTH) dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .wr_rst_n(wr_rst_n),
        .rd_rst_n(rd_rst_n),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .full(full),
        .rd_data(rd_data),
        .rd_en(rd_en),
        .empty(empty)
    );

    ////////////////////////////////////////////////////////////
    // Clock Generation (Different Frequencies)
    ////////////////////////////////////////////////////////////

    initial wr_clk = 0;
    always #5 wr_clk = ~wr_clk;   // 100 MHz

    initial rd_clk = 0;
    always #7 rd_clk = ~rd_clk;   // ~71 MHz

    ////////////////////////////////////////////////////////////
    // Reset
    ////////////////////////////////////////////////////////////

    initial begin
        wr_rst_n = 0;
        rd_rst_n = 0;
        wr_en    = 0;
        rd_en    = 0;
        wr_data  = 0;

        #20;
        wr_rst_n = 1;
        rd_rst_n = 1;
    end

    ////////////////////////////////////////////////////////////
    // Scoreboard (Reference Model)
    ////////////////////////////////////////////////////////////

    byte queue[$];

    ////////////////////////////////////////////////////////////
    // Write Process
    ////////////////////////////////////////////////////////////

    initial begin
        wait(wr_rst_n);

        repeat (200) begin
            @(posedge wr_clk);

            if (!full) begin
                wr_en   = $urandom_range(0,1);
                wr_data = $urandom_range(0,255);

                if (wr_en) begin
                    queue.push_back(wr_data);
                    $display("[WRITE] Data=%0d | Queue size=%0d", wr_data, queue.size());
                end
            end else begin
                wr_en = 0;
                $display("[WRITE] FIFO FULL");
            end
        end

        wr_en = 0;
    end

    ////////////////////////////////////////////////////////////
    // Read Process
    ////////////////////////////////////////////////////////////

    initial begin
        wait(rd_rst_n);

        forever begin
            @(posedge rd_clk);

            if (!empty && queue.size() > 0) begin
                rd_en = $urandom_range(0,1);

                if (rd_en) begin
                    #1; // allow rd_data to update

                    if (rd_data !== queue[0]) begin
                        $error("[ERROR] Expected=%0d Got=%0d", queue[0], rd_data);
                    end else begin
                        $display("[READ ] Data=%0d | Queue size=%0d", rd_data, queue.size());
                    end

                    queue.pop_front();
                end
            end else begin
                rd_en = 0;
                if (empty)
                    $display("[READ ] FIFO EMPTY");
            end
        end
    end

    ////////////////////////////////////////////////////////////
    // Simulation Control
    ////////////////////////////////////////////////////////////

    initial begin
        #5000;
        $display("Simulation Finished ✅");
        $finish;
    end

endmodule