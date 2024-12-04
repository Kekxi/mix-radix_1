module plantard_mm #(parameter data_width = 12)(
    input clk,rst,
    input [data_width-1:0] A_in, 
    output wire [data_width-1:0]  C_out
    );


    parameter BR = 38'd140307922925;
    parameter BR_shift = 26'd50397165;
    parameter R = 26'd61403905;
    parameter q = 12'd3329;
    parameter c_mod = 12'd447;

    // wire [37:0] BR; //12+26 =38
    // // wire [37:0] BR_q1; //12+26 =38
    // wire [25:0] BR_shift; // [2n-1:0] ----------- n=13

    wire [36:0] mul1; 
    wire [36:0] mul1_q; 
    wire [12:0] mul1_shift; 
    // wire [36:0] ABR;     // [3n-3:0]  
    // wire [12:0] ABR_shift; //[2n-1:n] n位

    wire [24:0] mul2; // 12+13=25位
    wire [24:0] mul2_q; // 12+13=25位
    // wire [24:0] z_mul; // 12+13=25位

    wire [25:0] add;
    wire [25:0] add_q;

    wire [23:0] C;
    // wire [23:0] C_q;
    
    wire [11:0] c_out;
    wire [11:0] c_d;

    // assign BR = B_in * R ;
    // // DFF #(.data_width(38)) d1(.clk(clk),.rst(rst),.d(BR),.q(BR_q1));

    // assign BR_shift = BR[25:0];

    // assign ABR = BR_shift * A_in;

    assign mul1 = BR_shift * A_in;
    DFF #(.data_width(37)) d1(.clk(clk),.rst(rst),.d(mul1),.q(mul1_q));
    assign mul1_shift = mul1_q[25:13];

    assign mul2 = mul1_shift * q;
    DFF #(.data_width(25)) d2(.clk(clk),.rst(rst),.d(mul2),.q(mul2_q));
    // assign z_mul = ABR_shift * q ;

    assign add = mul2_q + q;
    DFF #(.data_width(26)) d3(.clk(clk),.rst(rst),.d(add),.q(add_q));

    assign C = add_q[25:13] *c_mod;
    // DFF #(.data_width(24)) d5(.clk(clk),.rst(rst),.d(C),.q(C_q));

    assign c_out = C % q;
    assign c_d = (c_out == q) ? 0:c_out;
    DFF #(.data_width(24)) d4(.clk(clk),.rst(rst),.d(c_d),.q(C_out));

endmodule