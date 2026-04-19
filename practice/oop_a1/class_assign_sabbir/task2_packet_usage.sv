// Task 2 
`include "task1_packet_class.sv"

module task2_packet_usage;
  initial begin
    $display("Task 2: Packet Object Creation and Usage \n");

    // Create packet object
    packet pkt;

    // Assign values
    pkt = new();
    pkt.addr = 8'hAA;
    pkt.data = 8'hBB;
    pkt.write = 1'b1;

    // Call display function
    pkt.display();

    // Create another object with different values
    packet pkt2 = new();
    pkt2.addr = 8'h12;
    pkt2.data = 8'h34;
    pkt2.write = 1'b0;
    pkt2.display();

    $display("\n");
  end
endmodule