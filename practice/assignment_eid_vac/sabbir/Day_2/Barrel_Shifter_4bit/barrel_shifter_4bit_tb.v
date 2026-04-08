module barrel_shifter_4bit_tb;
  reg [3:0]a_tb;
  reg [1:0]sel_tb;
  wire [3:0]y_tb;
  integer i;
  
  reg [3:0]y_exp;
  
  barrel_shifter_4bit dut(.a(a_tb),
                          .sel(sel_tb),
                          .y(y_tb));
  
  
  task model(input [3:0]a_in,
             input [1:0]sel_in,
             output reg [3:0]y_out);
    begin
      case(sel_in)
        2'b00:y_out=a_in>>1;
        2'b01:y_out=a_in<<1;
        2'b10:y_out=$signed(a_in)>>>1;
        default:y_out=a_in;
      endcase
    end
  endtask
    
    initial begin
    //   $display("Starting Self Checking..");
    //   $dumpfile("dump.vcd");
      $dumpvars(1);
      for(i=0;i<45;i=i+1)
        begin
      	{sel_tb,a_tb}=i;
          model(a_tb,sel_tb,y_exp);
        #1;
          if(y_tb!==y_exp)
            $display("Fail: a_tb=%b sel_tb=%b y_tb=%b y_exp=%b",a_tb,sel_tb,y_tb,y_exp);
          else
            $display("Pass: a_tb=%b sel_tb=%b y_tb=%b y_exp=%b",a_tb,sel_tb,y_tb,y_exp);
        end
      $display("Testbench Finished");
      $finish;
      
      
    end
endmodule
    