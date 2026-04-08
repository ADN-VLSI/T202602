module adder_4bit_tb;
  reg [3:0]a_tb,b_tb;
  reg cin_tb;
  wire [3:0]sum_tb;
  wire cout_tb;
  
  integer i;
  reg [3:0]exp_sum;
  reg exp_cout;
  integer pass=0,fail=0;
  
  adder_4bit dut(.a(a_tb),.b(b_tb),.cin(cin_tb),.sum(sum_tb),.cout(cout_tb));
  
  task model;
    input [3:0]a_m,b_m;
    input cin_m;
    output [3:0]sum_m;
    output cout_m;
    begin
      {cout_m,sum_m}=a_m+b_m+cin_m; end
  endtask
  
  initial begin
    // $dumpfile("dump adder_4bit.vcd");
    // $dumpvars(0, adder_4bit_tb);
    for(i=0;i<512;i=i+1) begin
      cin_tb=i[8];
      a_tb=i[7:4];
      b_tb=i[3:0];
      
      model(a_tb,b_tb,cin_tb,exp_sum,exp_cout);
      #1;
      
      
      if(sum_tb !== exp_sum || cout_tb !== exp_cout) begin
        fail=fail+1;
        $display("Failed sum_tb=%b exp_sum=%b cout_tb=%b exp_cout=%b",sum_tb,exp_sum,cout_tb,exp_cout);
      end
      else begin
        pass=pass+1;
//       $display("Passed:%b",pass);
       end
    end
  $display("Pass:%d Fail:%d",pass,fail);
  $display("Checkout finished..");
  end
endmodule