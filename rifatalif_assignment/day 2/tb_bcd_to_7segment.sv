`timescale 1ns/1ps 
 
module tb_bcd_to_7seg; 
 
  // Inputs 
  logic [3:0] bcd; 
 
  // Output 
  logic [6:0] seg; 
 
  // DUT 
  bcd_to_7seg uut ( 
    .bcd(bcd), 
    .seg(seg) 
  ); 
 
  // Expected output function (self-checking) 
  function [6:0] expected_seg(input [3:0] val); 
    case(val) 
      4'd0: expected_seg = 7'b1111110; 
      4'd1: expected_seg = 7'b0110000; 
      4'd2: expected_seg = 7'b1101101; 
      4'd3: expected_seg = 7'b1111001; 
      4'd4: expected_seg = 7'b0110011; 
      4'd5: expected_seg = 7'b1011011; 
      4'd6: expected_seg = 7'b1011111; 
      4'd7: expected_seg = 7'b1110000; 
      4'd8: expected_seg = 7'b1111111; 
      4'd9: expected_seg = 7'b1111011; 
      default: expected_seg = 7'b0000000; 
    endcase 
  endfunction 
 
  integer i; 
 
  initial begin 
    $display("===== BCD to 7-Segment Test Start ====="); 
 
    // Waveform dump 
    $dumpfile("bcd7seg.vcd"); 
    $dumpvars(0, tb_bcd_to_7seg); 
 
    // Test all possible inputs (0–15) 
    for (i = 0; i < 16; i++) begin 
      bcd = i; 
      #10; 
 
      if (seg !== expected_seg(bcd)) begin 
        $error("FAIL: bcd=%0d | seg=%b (expected=%b)", 
                bcd, seg, expected_seg(bcd)); 
      end else begin 
        $display("PASS: bcd=%0d | seg=%b", bcd, seg); 
      end 
    end 
 
    $display("===== Test Finished ====="); 
    $finish; 
  end 
 
endmodule 