`timescale 1ns / 1ps

module stage_bf (
    input clk,rst,
    // input SREN,
    input [11:0] u,v,
    output [11:0] bf_upper,bf_lower
    );

    // wire clk_en;
    // assign clk_en = clk & SREN;

    wire [11:0] u_q1,u_q5;
    wire [11:0] mux_out1,mux_out2,mux_out3; 
    wire [11:0] mux_out4,mux_out5;
    wire [11:0] v_q1;
    wire [11:0] mult_out,add_out,sub_out;
    wire [11:0] add_out_q1,sub_out_q1;
    wire [11:0] w_q1;
    wire [11:0] sub_op1,sub_op2;
    
    parameter w = 12'd2285;

    //mux about signal u 
    DFF #(.data_width(12))  dff_u(.clk(clk),.rst(rst),.d(u),.q(u_q1));
    shift_4 #(.data_width(12)) shf_u (.clk(clk),.rst(rst),.din(u_q1),.dout(u_q5));
    assign mux_out1 = u_q5;
    
    //mux about signal v
    DFF #(.data_width(12))  dff_v(.clk(clk),.rst(rst),.d(v),.q(v_q1));
    assign mux_out3 = v_q1;
    modular_mul mult_pe0(.clk(clk),.rst(rst),.A_in(mux_out3),.B_in(mux_out4),.P_out(mult_out));
    assign mux_out2 =  mult_out;
    
    //mux about tf
    DFF #(.data_width(12)) dff_w1(.clk(clk),.rst(rst),.d(w),.q(w_q1));

    assign mux_out4 = w_q1;
    
    //mux about sub
    assign mux_out5 = mult_out;
    assign sub_op1 = mux_out1;
    assign sub_op2 = mux_out5;
    modular_substraction #(.data_width(12)) sub(.x_sub(sub_op1),.y_sub(sub_op2),.z_sub(sub_out)); 
    shift_7 dff_sub(.clk(clk),.rst(rst),.din(sub_out),.dout(sub_out_q1));   

    modular_add #(.data_width(12)) add(
               .x_add(mux_out1),
               .y_add(mux_out2),
               .z_add(add_out));
    
    shift_7 dff_add(.clk(clk),.rst(rst),.din(add_out),.dout(add_out_q1));

    assign bf_lower = add_out_q1;
    assign bf_upper = sub_out_q1;                                                                                                                                             
endmodule