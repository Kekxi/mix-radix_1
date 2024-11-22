module top_stage(
    input clk,rst,
    input [2:0] conf,
    output [1:0] done_flag);

    //fsm port signal
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

    // stage_bf_out  bf_0_upper,bf_0_lower
    wire [11:0] sbf_0_upper,sbf_0_lower;
    wire [11:0] sbf_1_upper,sbf_1_lower;
 
    // radix-4_bf_out  bf_0_upper,bf_0_lower
    wire [11:0] bf_0_upper,bf_0_lower;
    wire [11:0] bf_1_upper,bf_1_lower;

    //data into bfu
    wire [11:0] u0,v0,u1,v1;

    //data into banks
    wire [11:0] D0,D1,D2,D3;
    wire [11:0] D_0,D_1,D_2,D_3;

    wire [11:0] d0,d1,d2,d3;
    assign d0 = (swen == 1) ? D0 : D_0;
    assign d1 = (swen == 1) ? D1 : D_1;
    assign d2 = (swen == 1) ? D2 : D_2;
    assign d3 = (swen == 1) ? D3 : D_3;

    //memory map port signal
    wire [4:0] new_address_0,new_address_1,new_address_2,new_address_3;
    wire [1:0] bank_number_0,bank_number_1,bank_number_2,bank_number_3;    

    //arbiter port signal
    wire [1:0] sel_a_0,sel_a_1,sel_a_2,sel_a_3;

    wire [4:0] bank_address_0,bank_address_1,bank_address_2,bank_address_3; 

    wire [4:0] bank_address_0_dy,bank_address_1_dy;
    wire [4:0] bank_address_2_dy,bank_address_3_dy;    

    //twiddle factors into banks
    wire [35:0] w;  
    wire [11:0] win1,win2,win3;
    
    //twiddle factor address
    wire [5:0] tf_address;

    fsm m1(.clk(clk),.rst(rst),
           .conf(conf),
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

  shift_13 #(.data_width(5)) shf1 (.clk(clk),.rst(rst),.din(bank_address_0),.dout(bank_address_0_dy));   
  shift_13 #(.data_width(5)) shf2 (.clk(clk),.rst(rst),.din(bank_address_1),.dout(bank_address_1_dy)); 
  shift_13 #(.data_width(5)) shf3 (.clk(clk),.rst(rst),.din(bank_address_2),.dout(bank_address_2_dy)); 
  shift_13 #(.data_width(5)) shf4 (.clk(clk),.rst(rst),.din(bank_address_3),.dout(bank_address_3_dy));     
    

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

   stage_bf bf_0(
              .clk(clk_en),.rst(rst),
            //   .SREN(sren),
              .u(u0),.v(u1),
              .bf_upper(sbf_0_upper),.bf_lower(sbf_0_lower)
              ); 

   stage_bf bf_1(
              .clk(clk_en),.rst(rst),
            //   .SREN(sren),
              .u(v0),.v(v1),
              .bf_upper(sbf_1_upper),.bf_lower(sbf_1_lower)
              );  

  network_bf_out mux3(
                       .clk(clk_en),.rst(rst),
                       .bf_0_upper(sbf_0_upper),.bf_0_lower(sbf_0_lower),
                       .bf_1_upper(sbf_1_upper),.bf_1_lower(sbf_1_lower),
                       .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
                       .sel_a_2(sel_a_2),
                       .sel_a_3(sel_a_3),
                       .d0(D0),.d1(D1),.d2(D2),.d3(D3));  

   compact_bf bf(
           .clk(clk),
           .rst(rst),
           .u0(u0),.v0(u1),.u1(v0),.v1(v1),
           .wa1(win1),.wa2(win2),.wa3(win3),
        //    .sel(sel),
           .bf_0_upper(bf_0_upper),.bf_0_lower(bf_0_lower),
           .bf_1_upper(bf_1_upper),.bf_1_lower(bf_1_lower)); 

  network_bf_out mux4(
                       .clk(clk),.rst(rst),
                       .bf_0_upper(bf_0_upper),.bf_0_lower(bf_0_lower),
                       .bf_1_upper(bf_1_upper),.bf_1_lower(bf_1_lower),
                       .sel_a_0(sel_a_0),.sel_a_1(sel_a_1),
                       .sel_a_2(sel_a_2),
                       .sel_a_3(sel_a_3),
                       .d0(D_0),.d1(D_1),.d2(D_2),.d3(D_3));  

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