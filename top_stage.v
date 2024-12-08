module top_stage(
    input clk,rst,
    input [2:0] conf,
    output [1:0] done_flag);

    //fsm port signal
    wire sel;
    wire [4:0] i;
    wire [4:0] k,j;
    wire [3:0] p;
    wire [1:0] done_flag;
    wire swen,sren,sen;
    wire iwen,iren,ien;
    wire clk_en;
    assign clk_en = clk & sen;

    //stage_address_generator port signal
    wire [6:0] old_address_0,old_address_1,old_address_2,old_address_3;

    // data_in 
    wire [11:0] q0,q1,q2,q3;

 
    // radix-4_bf_out  bf_0_upper,bf_0_lower
    wire [11:0] bf_0_upper,bf_0_lower;
    wire [11:0] bf_1_upper,bf_1_lower;

    //data into bfu
    wire [11:0] u0,v0,u1,v1;

    // //data into banks
    wire [11:0] d0,d1,d2,d3;

    //memory map port signal
    wire [4:0] new_address_0,new_address_1,new_address_2,new_address_3;
    wire [1:0] bank_number_0,bank_number_1,bank_number_2,bank_number_3;    

    //arbiter port signal
    wire [1:0] sel_a_0,sel_a_1,sel_a_2,sel_a_3;

    wire [4:0] bank_address_0,bank_address_1,bank_address_2,bank_address_3; 

    wire [4:0] bank_address_0_dy_reg_s,bank_address_1_dy_reg_s,bank_address_2_dy_reg_s,bank_address_3_dy_reg_s;
    wire [4:0] bank_address_0_dy_reg_i,bank_address_1_dy_reg_i,bank_address_2_dy_reg_i,bank_address_3_dy_reg_i;

    wire [4:0] bank_address_0_dy,bank_address_1_dy;
    wire [4:0] bank_address_2_dy,bank_address_3_dy;    

    assign bank_address_0_dy = sel == 0 ?  bank_address_0_dy_reg_s :bank_address_0_dy_reg_i;
    assign bank_address_1_dy = sel == 0 ?  bank_address_1_dy_reg_s :bank_address_1_dy_reg_i;
    assign bank_address_2_dy = sel == 0 ?  bank_address_2_dy_reg_s :bank_address_2_dy_reg_i;
    assign bank_address_3_dy = sel == 0 ?  bank_address_3_dy_reg_s :bank_address_3_dy_reg_i;

    //twiddle factors into banks
    wire [35:0] w;  
    wire [11:0] win1,win2,win3;
    
    //twiddle factor address
    wire [5:0] tf_address;

    fsm m1( .clk(clk),.rst(rst),
            .conf(conf),
            .sel(sel),
            .i(i),
            .j(j),
            .k(k),
            .p(p),
            .swen(swen),
            .sren(sren),
            .sen(sen),
            .iwen(iwen),
            .iren(iren),
            .ien(ien),
            .done_flag(done_flag));

    address_generator m2(
               .clk(clk),.rst(rst),
               .i(i),
               .j(j),
               .k(k),
               .p(p),               
               .old_address_0(old_address_0),.old_address_1(old_address_1),
               .old_address_2(old_address_2),.old_address_3(old_address_3));


   conflict_free_memory_map map(
              .clk(clk),
              .rst(rst),
              .old_address_0(old_address_0),
              .old_address_1(old_address_1),
              .old_address_2(old_address_2),
              .old_address_3(old_address_3),
              .new_address_0(new_address_0),
              .new_address_1(new_address_1),
              .new_address_2(new_address_2),
              .new_address_3(new_address_3),
              .bank_number_0(bank_number_0),
              .bank_number_1(bank_number_1),
              .bank_number_2(bank_number_2),
              .bank_number_3(bank_number_3));    

  arbiter m3(
             .a0(bank_number_0),.a1(bank_number_1),
             .a2(bank_number_2),.a3(bank_number_3),
             .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
             .sel_a_2(sel_a_2),.sel_a_3(sel_a_3)); 


  network_bank_in mux1(
                 .b0(new_address_0),.b1(new_address_1),
                 .b2(new_address_2),.b3(new_address_3),
                 .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
                 .sel_a_2(sel_a_2),.sel_a_3(sel_a_3),
                 .new_address_0(bank_address_0),.new_address_1(bank_address_1),
                 .new_address_2(bank_address_2),.new_address_3(bank_address_3)
                 );   

  shift_7 #(.data_width(5)) shf1 (.clk(clk_en),.rst(rst),.din(bank_address_0),.dout(bank_address_0_dy_reg_s));   
  shift_7 #(.data_width(5)) shf2 (.clk(clk_en),.rst(rst),.din(bank_address_1),.dout(bank_address_1_dy_reg_s)); 
  shift_7 #(.data_width(5)) shf3 (.clk(clk_en),.rst(rst),.din(bank_address_2),.dout(bank_address_2_dy_reg_s)); 
  shift_7 #(.data_width(5)) shf4 (.clk(clk_en),.rst(rst),.din(bank_address_3),.dout(bank_address_3_dy_reg_s));     

  shift_13 #(.data_width(5)) shf5 (.clk(clk),.rst(rst),.din(bank_address_0),.dout(bank_address_0_dy_reg_i));   
  shift_13 #(.data_width(5)) shf6 (.clk(clk),.rst(rst),.din(bank_address_1),.dout(bank_address_1_dy_reg_i)); 
  shift_13 #(.data_width(5)) shf7 (.clk(clk),.rst(rst),.din(bank_address_2),.dout(bank_address_2_dy_reg_i)); 
  shift_13 #(.data_width(5)) shf8 (.clk(clk),.rst(rst),.din(bank_address_3),.dout(bank_address_3_dy_reg_i));     
    

  data_bank bank_0(
                   .clk(clk),
                   .rst(rst),
                   .A1(bank_address_0_dy),
                   .A2(bank_address_0),
                   .D(d0),
                   .SWEN(swen),
                   .SREN(sren),
                   .SEN(sen),
                   .IWEN(iwen),
                   .IREN(iren),
                   .IEN(ien),
                   .Q(q0));
         
  data_bank bank_1(
                   .clk(clk),
                   .rst(rst),
                   .A1(bank_address_1_dy),
                   .A2(bank_address_1),
                   .D(d1),
                   .SWEN(swen),
                   .SREN(sren),
                   .SEN(sen),
                   .IWEN(iwen),
                   .IREN(iren),
                   .IEN(ien),
                   .Q(q1));
             
  data_bank bank_2(
                   .clk(clk),
                   .rst(rst),
                   .A1(bank_address_2_dy),
                   .A2(bank_address_2),
                   .D(d2),
                   .SWEN(swen),
                   .SREN(sren),
                   .SEN(sen),
                   .IWEN(iwen),
                   .IREN(iren),
                   .IEN(ien),
                   .Q(q2));  
           
  data_bank bank_3(
                   .clk(clk),
                   .rst(rst),
                   .A1(bank_address_3_dy),
                   .A2(bank_address_3),
                   .D(d3),
                   .SWEN(swen),
                   .SREN(sren),
                   .SEN(sen),
                   .IWEN(iwen),
                   .IREN(iren),
                   .IEN(ien),
                   .Q(q3));

   network_bf_in mux2(
                      .clk(clk),.rst(rst),
                      .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),.sel_a_2(sel_a_2),
                      .sel_a_3(sel_a_3),
                      .q0(q0),.q1(q1),.q2(q2),.q3(q3),
                      .u0(u0),.v0(v0),.u1(u1),.v1(v1)); 

   compact_bf bf(
           .clk(clk),
           .rst(rst),
           .u0(u0),.v0(u1),.u1(v0),.v1(v1),
           .wa1(win1),.wa2(win2),.wa3(win3),
           .sel(sel),
           .sen(sen),
           .ien(ien),
           .bf_0_upper(bf_0_upper),.bf_0_lower(bf_0_lower),
           .bf_1_upper(bf_1_upper),.bf_1_lower(bf_1_lower)); 

  network_bf_out mux4(
                       .clk(clk),.rst(rst),
                       .sel(sel),
                       .sen(sen),
                      //  .ien(ien),
                       .bf_0_upper(bf_0_upper),.bf_0_lower(bf_0_lower),
                       .bf_1_upper(bf_1_upper),.bf_1_lower(bf_1_lower),
                       .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
                       .sel_a_2(sel_a_2),
                       .sel_a_3(sel_a_3),
                       .d0(d0),.d1(d1),.d2(d2),.d3(d3));  

  tf_address_generator m_tf(.clk(clk),.rst(rst),.k(k),.p(p),.tf_address(tf_address));  
  
  assign win1 = w[35:24];
  assign win2 = w[23:12];
  assign win3 = w[11:0];

  tf_ROM rom0(
              .clk(clk),
              .A(tf_address),
              .IREN(iren),
              .Q(w));

endmodule