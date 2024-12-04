module pmm_tb;

   reg clk,rst;
   reg [11:0]A_in;
   wire C_out;


   initial
  begin
    clk=1'b0;
    forever #5 clk=~clk;
  end
  
  // initial 
  // begin
  //   B_in = 12'd1;
  //   #10 B_in = 12'd2285;
  // end
  
    initial 
  begin
    // // A_in = 12'd2285;
    // $readmemb("D:/NTT/ntt/2_4_mixed_ntt/data.txt",A_in);

    // A_in = 12'd1;
    #10 A_in = 12'd190;
    #10 A_in = 12'd2002;
    #10 A_in = 12'd3015;
    #10 A_in = 12'd484;
    #10 A_in = 12'd1938;
    #10 A_in = 12'd1598;
    #10 A_in = 12'd1016;
    #10 A_in = 12'd3063;
    #10 A_in = 12'd2288;
  end


plantard_mm tb_pmm(
    .clk(clk),.rst(rst),
    .A_in(A_in),
    .C_out(C_out));

endmodule



