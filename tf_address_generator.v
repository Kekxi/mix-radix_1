module tf_address_generator(
    input clk,rst,
    input [4:0] k,
    input [3:0] p,
    output wire [5:0] tf_address
    );
    
    reg [8:0] tf_address_reg;
    wire [8:0] tf_address_tmp;
    //sel = 0 NTT mode; sel = 1 INTT mode
    assign tf_address_tmp = tf_address_reg;
    
    DFF #(.data_width(12)) dff_tf(.clk(clk),.rst(rst),.d(tf_address_tmp),.q(tf_address));
    
    always@(*)
    begin
      case(p)
      2: tf_address_reg = k; 
      1: tf_address_reg = k + 2;
      0: tf_address_reg = k + 10;
      default:tf_address_reg = 0;
      endcase
    end
endmodule