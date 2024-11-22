module stage_tb;

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
  

top_stage tb_stage(
    .clk(clk),.rst(rst),
    .conf(conf),
    .done_flag(done_flag));

  initial
  begin 
     $readmemb("F:/NTT/ntt/mixntt/bank0.txt",stage_tb.tb_stage.bank_0.bank);
     $readmemb("F:/NTT/ntt/mixntt/bank1.txt",stage_tb.tb_stage.bank_1.bank);
     $readmemb("F:/NTT/ntt/mixntt/bank2.txt",stage_tb.tb_stage.bank_2.bank);
     $readmemb("F:/NTT/ntt/mixntt/bank3.txt",stage_tb.tb_stage.bank_3.bank);
  end

endmodule