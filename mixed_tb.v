module mixed_tb;

   reg clk,rst;
   reg [2:0]conf;
   wire [1:0] done_flag;


   initial
  begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  initial 
  begin
    conf = 0;
    rst = 1;
    # 7 rst = 0;
    # 2 conf = 1;
    # 325 conf = 3;
    # 170 conf = 2;
    // # 15 conf = 2;
    # 960 conf = 4;
  end
  

top_stage tb_mixed(
    .clk(clk),.rst(rst),
    .conf(conf),
    .done_flag(done_flag));

  initial
  begin 
     $readmemb("D:/NTT/ntt/2_4_mixed_ntt/bank0.txt",mixed_tb.tb_mixed.bank_0.bank);
     $readmemb("D:/NTT/ntt/2_4_mixed_ntt/bank1.txt",mixed_tb.tb_mixed.bank_1.bank);
     $readmemb("D:/NTT/ntt/2_4_mixed_ntt/bank2.txt",mixed_tb.tb_mixed.bank_2.bank);
     $readmemb("D:/NTT/ntt/2_4_mixed_ntt/bank3.txt",mixed_tb.tb_mixed.bank_3.bank);
  end

endmodule